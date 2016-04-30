# Introduction to implementing a checkout

This library provides logic for common steps in a checkout. You can use these
steps in your checkout controllers. This example will be in Ruby on Rails but it
could be any ruby framework or library, even Rack.

## Dependency container

First of all let's create a dependency container for an imaginary e-commerce
framework.

``` ruby
class AppContainer < MarketTown::Checkout::Dependencies
  class Fulfilments
    def can_fulfil_address?(delivery_address)
      Ecom::DistributionService.new.check_address(delivery_address)
    end

    def propose_shipments(state)
      state[:order].shipments << Ecom::Shipments.new.propose(state[:delivery_address])
    end
  end

  class AddressStorage
    def store(state)
      case state[:address_type]
      when :delivery
        state[:user].shipment_addresses << state[:delivery_address]
      when :billing
        state[:user].billing_addresses << state[:billing_address]
      end
    end
  end

  class Finish
    def address_step(state)
      state[:order].update!(step: :delivery)
    end
  end

  def fulfilments
    Fulfilments.new
  end

  def address_storage
    AddressStorage.new
  end

  def finish
    Finish.new
  end
end
```

Inside this container we wrote some simple adapters to our e-commerce framework.
You can of course keep these adapters in another file, we've kept them here to
keep the example simple. The container exposes the adapters via methods that
are used by MarketTown::Checkout steps.

## Generic step controller

Now we can implement our base step controller:

``` ruby
class StepController < ApplicationController
  def edit
    @order = Ecom::Order.find_by(user: current_user)
  end

  def update
    @order = Ecom::Order.find_by(user: current_user)
    process_step
    redirect_to checkout_path(@order)
  rescue MarketTown::Checkout::Error => e
    flash.now[:errors] = [e.error]
    render :edit
  rescue ActiveRecord::RecordInvalid
    render :edit
  end

  private

  def process_step
    MarketTown::Checkout.process_step(step: step_name,
                                      dependencies: AppContainer.new,
                                      state: step_state)
  end

  def step_state
    { user: current_user,
      order: @order }
  end
end
```

## Address step controller

And now let's create our address checkout step:

``` ruby
class AddressStepController < StepController
  private

  def step_name
    :address
  end

  def step_state
    address_params = %i(name address_1 locality postal_code country save)

    super.merge(params.require(:order).permit(billing_address: address_params,
                                              delivery_address: address_params))
  end
end
```

You could create a controller for each step in the same way.
