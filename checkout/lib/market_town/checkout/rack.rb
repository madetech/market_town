require 'rack'
require_relative './rack/response'
require_relative './rack/step'
require_relative './rack/not_found'

module MarketTown
  module Checkout
    module Rack
      extend self

      STEPS = %i(cart address)

      def app(config = {})
        steps = config[:steps] || STEPS
        builder = ::Rack::Builder.new

        steps.each do |step_name|
          builder.map("/checkout/#{step_name}") { run Step.new(step_name) }
        end

        builder.run NotFound.new
        builder.to_app
      end
    end
  end
end
