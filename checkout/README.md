# Market Town: Checkout

This gem provides Checkout business logic. The aim is to provide
framework independent logic for handling the steps of e-commerce
checkouts.

Using dependency injection you can provide implementation specific
logic for applying promotions, saving addresses, taking payments,
etc. in your e-commerce store. Dependency containers can be written
to support Spree, Webhooks and more.

## Aims

 - Handle common usecases of checkout behaviour
 - Provide a Spree dependency container for writing your own
   checkout controllers that speak to Spree objects underneath
 - Provide a Webhook dependency container that will forward calls
   onto a HTTPS interface of your choice

## Implementing a checkout

This library provides logic for common steps in a checkout. You can
use these steps in your checkout controllers. This example will be
in Ruby on Rails but it could be any ruby framework or library,
even Rack.

First of all let's create a dependency container for an imaginary
e-commerce framework.

``` ruby
class AppContainer < MarketTown::Checkout::Dependencies
  class Fulfilments
    def can_fulfil_address?(delivery_address)
      Ecom::DistributionService.new.check_address(delivery_address)
    end

    def propose_shipments(state)
      state[:shipments] << Ecom::Shipments.new.propose(state[:delivery_address])
    end
  end

  class AddressStorage
    def store(state)
      case state[:address_type]
      when :delivery
        User.find_by(state[:user_id]).shipment_addresses << state[:delivery_address]
      when :billing
        User.find_by(state[:user_id]).billing_addresses << state[:billing_address]
      end
    end
  end

  class CompleteStep
    def address(state)
      state[:order].update!(step: :delivery)
    end
  end

  def fulfilments
    Fulfilments.new
  end

  def address_storage
    AddressStorage.new
  end

  def complete_step
    CompleteStep.new
  end
end
```

Inside this container we wrote some simple adapters to our e-commerce framework.
You can of course keep these adapters in another file, we've kept them here to
keep the example simple. The container exposes the adapters via methods that
are used by MarketTown::Checkout steps.

Now we can implement our checkout address step controller:

``` ruby
class AddressStepController < ApplicationController
  def edit
    @order = Ecom::Order.find_by(user: current_user)
  end

  def update
    @order = Ecom::Order.find_by(user: current_user)
    process_step
  rescue MarketTown::Checkout::Error => e
    flash.now[:errors] = [e.error]
    render :edit
  end

  private

  def order_params
    address_params = %i(name address_1 locality postal_code country save)

    params.require(:order).permit(billing_address: address_params,
                                  delivery_address: address_params)
                          .merge(user_id: current_user.id,
                                 shipments: @order.shipments)
  end

  def process_step
    MarketTown::Checkout.process_step(step: :address,
                                      dependencies: AppContainer.new,
                                      state: order_params)
  end
end
```
