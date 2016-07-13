module MarketTown
  module Checkout
    module Rack
      class NotFound
        include Response

        def call(env)
          json_response(404, error: 'Not found')
        end
      end
    end
  end
end
