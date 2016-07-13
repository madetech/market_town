module MarketTown
  module Checkout
    module Rack
      class Step
        include Response

        attr_reader :step_name

        def initialize(step_name)
          @step_name = step_name
        end

        def call(env)
          json_response(200, step_name: step_name)
        end
      end
    end
  end
end
