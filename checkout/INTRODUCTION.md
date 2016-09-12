# Introduction to implementing a checkout

`MarketTown::Checkout` provides classes for each common step in a checkout. You can call these classes in your own controllers. The purpose is to allow you to insert a layer of abstraction between your controllers/views and your e-commerce integration whether it be Spree or Solidus or something else. This gives you an easier upgrade path when you want to update your e-commerce backend as you're dependent on a smaller, cleaner and better documented interface.

In this introduction we're going to setup a checkout for an imaginary e-commerce framework. We'll use `MarketTown::Checkout` step classes in a rails controller but we'll also need to create our own integrations for our imaginary dependency. This setup should give you an overview of how `MarketTown::Checkout` works.

## Address Step

We'll start by defining our address step controller. You could serve all the steps of a checkout by the same controller action, or multiple actions within one controller. Today we'll use a single controller per step in order to keep things clear and simple.

``` ruby
class AddressStepController < ApplicationController
  def edit
    @order = Ecom::Order.find_by(user: current_user)
  end

  def update
    @order = Ecom::Order.find_by(user: current_user)

    address_step = MarketTown::Checkout::AddressStep.new(AppContainer.new)
    address_step.process(user: current_user, order: @order)

    redirect_to checkout_delivery_path(@order)
  rescue MarketTown::Checkout::Error => e
    flash.now[:errors] = [e.error]
    render :edit
  rescue ActiveRecord::RecordInvalid
    render :edit
  end
end
```

The `AddressStepController#edit` action simply initialises the order object of our imaginary framework. This order object is likely a model, used in the view.

As for the `#update` action, there's a bit more going on here:

1. We load the order object for the current user
2. Initialise the address step class with a dependency container
3. We process the step
4. Then depending on if we're successful:
    - If successful we redirect to the `#checkout_delivery_path` redirector
    - On `MarketTown::Checkout::Error` exception we display the error as a flash
    - On ActiveRecord validation error we display those in the view

## Dependency container

``` ruby
address_step = MarketTown::Checkout::AddressStep.new(AppContainer.new)
```

If we take a closer look at the initialisation of the `MarketTown::Checkout::AddressStep` class we can see `AppContainer` is passed to the `AddressStep` constructor. This is a simple dependency injection container that has a few methods that return instances of other classes.

[![Screenshot of docs for MarketTown::Checkout::AddressStep ](https://www.dropbox.com/s/ddt9vlqav4u0pc7/Screenshot%202016-09-12%2012.34.59.png?raw=1)](http://madetech.github.io/market_town/MarketTown/Checkout/AddressStep.html)

By looking at the documentation for the [`MarketTown::Checkout::AddressStep`](http://madetech.github.io/market_town/MarketTown/Checkout/AddressStep.html) we can see that it has several dependencies:

 - `Contracts::UserAddressStorage#store_billing_address`
 - `Contracts::UserAddressStorage#store_delivery_address`
 - `Contracts::Order#set_addresses`
 - `Contracts::Fulfilments#propose_shipments`
 - `Contracts::Fulfilments#can_fulfil_shipments?`
 - `Contracts::Fulfilments#apply_shipment_costs`
 - `Contracts::Finish#address_step`

The container will need to implement methods for each class. So for the `AddressStep` we need `#fulfilments`, `#user_address_storage` and `#finish`.

``` ruby
class AppContainer < MarketTown::Checkout::Dependencies
  class Finish; end
  class Fulfilments; end
  class Order; end
  class UserAddressStorage; end

  def finish
    Finish.new
  end

  def fulfilments
    Fulfilments.new
  end

  def order
    Order.new
  end

  def user_address_storage
    UserAddressStorage.new
  end
end
```

As you can see we've got our integration objects being returned from the `AppContainer` methods now.

## Integrations

The objects returned from our dependency container are integration drivers. Each object provides methods for dealing with a particular topic of checkout. The class names should give you an idea of what they do, `UserAddressStorage` deals with storing the user's address, `Fulfilments` deals with the shipment of orders. The only oddly named driver is `Finish` which deals with the finalisation of a step, i.e. saving the order back to the database and progressing a state machine to the next step.

The integration drivers follow the [adapter pattern](https://en.wikipedia.org/wiki/Adapter_pattern) so we can switch out drivers whenever we want to use a different implementation. For example, you may have been using the Spree Fulfilment driver that comes with `MarketTown::Checkout` but now want to separate that logic into a separate service. You'd just need to implement the [Fulfilment contract](http://madetech.github.io/market_town/MarketTown/Checkout/Contracts/Fulfilments.html), which could call out to your fulfilment service over HTTPS or RabbitMQ or whatever.

The `AddressStep` requires three methods to be defined in the Fulfilment driver: `#propose_shipments`, `#can_fulfil_shipments?` and `#apply_shipment_costs`.

``` ruby
class Fulfilments
  def propose_shipments(state)
    state[:order].create_proposed_shipments
    nil
  end

  def can_fulfil_shipments?(state)
    all_shipments_have_delivery_rates(state[:order])
  end

  def apply_shipment_costs(state)
    # not required for this implementation
  end

  private

  def all_shipments_have_delivery_rates
    order.shipments.all? { |shipment| shipment.delivery_rate.present? }
  end
end
```

Each of the methods implement a specific piece of functionality expected in most Address steps of checkout. You'll notice that `#apply_shipment_costs` does nothing in this implementation. It's okay not to implement all the behaviour asked for by the `AddressStep` if it is not applicable for a particular integration.

There are two type of method contracts (or interfaces) that all driver methods should adhere to:

``` ruby
# Command method
#
# A command method should do something then always return nil. It should blow up
# with an exception upon failure.
#
def method_name(state)
  do_something
  nil
end

# Boolean query method
#
# A boolean query method should return true or false, answering the question
# asked in the method name.
#
def method_name?(state)
  true # or false
end
```

We've defined all contracts as [classes within this project](https://github.com/madetech/market_town/tree/improve_checkout_intro/checkout/lib/market_town/checkout/contracts). These classes also have RSpec shared examples which you can use to test the interface of your own custom integrations.

``` ruby
module MarketTown::Checkout
  describe Contracts do
    let(:state) { { order: create(:order) } }

    describe Spree::UserAddressStorage do
      before(:each) do
        create(:country, iso: 'US', iso3: 'USA')
        state[:billing_address] = mock_address
        state[:delivery_address] = mock_address
      end

      it_behaves_like 'UserAddressStorage'
    end

    describe Spree::Fulfilments do
      it_behaves_like 'Fulfilments'
    end
  end
end
```

The example above is from our own [Spree contracts spec](https://github.com/madetech/market_town/blob/improve_checkout_intro/checkout/spec/checkout/integrations/spree/contracts_spec.rb) to give you an idea how to use the shared examples.

Whilst we're talking about testing integration it's worth looking at the whole [`spec/checkout/integrations/`](https://github.com/madetech/market_town/tree/improve_checkout_intro/checkout/spec/checkout/integrations) directory as this will give you a good idea how to test your own integrations.

## Processing step

``` ruby
address_step.process(user: current_user, order: @order)
```

Once we've initialised our `AddressStep` object we can then call `#process` on it. This method is provided by all step classes and accepts a single argument, a hash know as the `state` object. This is where things like the order object, user object, are passed in so that the address step can be processed.

There is a differentiation between constructor dependencies and arguments required in order to process the step. The dependencies are injected to provide behaviour in order to complete the step whereas arguments are passed in to be acted upon.

The state object is passed into each sub step contained within the step class.

``` ruby
module MarketTown
  module Checkout
    class AddressStep < Step
      steps :validate_billing_address,
            :use_billing_address_as_delivery_address,
            :validate_delivery_address,
            :set_order_addresses,
            :store_user_addresses,
            :propose_shipments,
            :validate_shipments,
            :apply_shipment_costs,
            :finish_address_step
    end
  end
end
```

The above is an incomplete excerpt from the [`AddressStep` class](https://github.com/madetech/market_town/blob/master/checkout/lib/market_town/checkout/steps/address_step.rb), showing you the listing of sub steps that are taken in order to complete the step.

Each one of these symbols is a method defined within the step class. Each one in turn accepts the state object and then performs the actions necessary to complete the step.

``` ruby
# Tries to proposes shipments to delivery address ready to be confirmed at
# delivery step.
#
def propose_shipments(state)
  deps.fulfilments.propose_shipments(state)
rescue MissingDependency
  add_dependency_missing_warning(state, :cannot_propose_shipments)
end

# Tries to validate shipments
#
# @raise [CannotFulfilShipmentsError]
#
def validate_shipments(state)
  unless deps.fulfilments.can_fulfil_shipments?(state)
    raise CannotFulfilShipmentsError.new(state[:shipments])
  end
rescue MissingDependency
  add_dependency_missing_warning(state, :cannot_validate_shipments)
end

# Tries to apply shipment costs to delivery address ready to be confirmed at
# delivery step.
#
def apply_shipment_costs(state)
  deps.fulfilments.apply_shipment_costs(state)
rescue MissingDependency
  add_dependency_missing_warning(state, :cannot_apply_shipment_costs)
end
```

Above are three steps from the `AddressStep` for handling fulfilments. You'll notice `#deps` being called, this is our application container. If a method is not defined in our application a `MissingDependency` exception is thrown and caught where a warning is output to the logger.

The role of a step class is to document and orchestrate the integrations. If you need to customise the flow of your checkout, you can extend or create your own steps instead. For example, you might like to allow delivery address to be used as billing address rather than the other way around:

``` ruby
class MyAddressStep < MarketTown::Checkout::AddressStep
  # Here we override the step order as defined in AddressStep. We
  # also replace #use_billing_address_as_delivery_address with
  # #use_delivery_address_as_billing_address.
  #
  steps :validate_delivery_address,
       :use_delivery_address_as_billing_address,
       :validate_billing_address,
       :ensure_delivery,
       :store_addresses,
       :propose_shipments,
       :finish_address_step

  protected

  def use_delivery_address_as_billing_address(state)
   if state[:use_delivery_address] == true
     state.merge(billing_address: state[:delivery_address])
   end
  end
end
```

All we've done here is redefined the sub steps for the address step, and defined one custom step, `#use_delivery_address_as_billing_address`.

There is more information in the API docs regarding [extending steps](http://madetech.github.io/market_town/MarketTown/Checkout/Step.html).

## Conclusion

So hopefully we've given you a good outline to how most of the components of `MarketTown::Checkout` work.

The aim of this project is to provide a way of abstracting your applications away from specific e-commerce frameworks to make change easier. To do this it not only provides you with sensible defaults but also the structure in which to implement your own solutions.
