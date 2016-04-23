# MarketTown is a collection of gems for providing e-commerce functionality to
# ruby apps.
#
# Maintained by Luke Morton. MIT Licensed.
#
module MarketTown
  # {Checkout} provides a simple interface to perform a single step in a
  # checkout process.
  #
  # ## Processing a step
  #
  # If we wanted to process the delivery step of an order we would do something
  # like this:
  #
  # ``` ruby
  # order = Order.find(1)
  #
  # delivery_address = { name: 'Luke Morton',
  #                      address_1: '21 Cool St',
  #                      locality: 'London',
  #                      postal_code: 'N1 1PQ',
  #                      country: 'GB' }
  #
  # MarketTown::Checkout.process_step(step: :delivery,
  #                                   dependencies: AppContainer.new,
  #                                   state: { order: order,
  #                                            delivery_address: delivery_address,
  #                                            delivery_method: :next_day })
  # ```
  #
  # To find out more about `AppContainer` please see {Dependencies}.
  #
  # ## Available steps
  #
  #  - {AddressStep} – Handles the taking of billing and delivery addresses
  #  - {DeliveryStep} – Handles the choosing of delivery method
  #  - {CompleteStep} – Handles completion of order
  #
  module Checkout
    extend self

    # @param [Hash] options
    # @option options [Symbol] :step One of `:address`, `:delivery`, `:complete`
    # @option options [Dependencies] :dependencies
    # @option options [Hash] :state A step dependant Hash
    #
    def process_step(options)
      step = const_get(options.fetch(:step).to_s.capitalize << 'Step')
      step.new(options.fetch(:dependencies)).process(options.fetch(:state))
    end
  end
end

require_relative './checkout/models/address'
require_relative './checkout/missing_dependency'
require_relative './checkout/dependencies'
require_relative './checkout/error'
require_relative './checkout/steps/step'
require_relative './checkout/steps/address_step'
require_relative './checkout/steps/delivery_step'
require_relative './checkout/steps/complete_step'
