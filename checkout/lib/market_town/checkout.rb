module MarketTown
  module Checkout
    extend self

    def process_step(options)
      step = const_get(options.fetch(:step).to_s.capitalize << 'Step')
      Process.new(options.fetch(:dependencies)).process(step, options.fetch(:state))
    end
  end
end

require_relative './checkout/models/address'
require_relative './checkout/dependencies'
require_relative './checkout/error'
require_relative './checkout/process'
require_relative './checkout/steps/step'
require_relative './checkout/steps/address_step'
require_relative './checkout/steps/delivery_step'
require_relative './checkout/steps/complete_step'
