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

First of all let's create a Dependency container for an imaginary
e-commerce framework.

``` ruby
class AppContainer < MarketTown::Checkout::Dependencies
  def fulfilments
    Ecom::Fulfilments.new
  end

  def notifications
    AppMailer.new
  end

  def address_storage
    Ecom::AddressStorage.new
  end

  def payment_gateway
    Ecom::PaymentGateway.new
  end
end
```

Now we can implement our checkout address step controller:

``` ruby
class AddressStepController < ApplicationController
  def edit
    @order = Ecom::Order.find_by(user: current_user)
  end

  def update
    @order = Ecom::Order.find_by(user: current_user)
    MarketTown::Checkout::AddressStep.new(AppContainer.new).process(order.to_h)
  rescue MarketTown::Checkout::AddressStep::InvalidAddressError
    flash.now[:errors] = [:invalid_address_error]
    render :edit
  rescue MarketTown::Checkout::AddressStep::CannotFulfilAddressError
    flash.now[:errors] = [:cannot_fulfil_address_error]
    render :edit
  end
end
```
