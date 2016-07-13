require 'json'

module MarketTown
  module Checkout
    module Rack
      module Response
        def json_response(status, object)
          ::Rack::Response.new([JSON.dump(object)], status, json_headers)
        end

        private

        def json_headers
          { 'Content-Type' => 'application/json' }
        end
      end
    end
  end
end
