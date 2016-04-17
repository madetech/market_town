module MarketTown
  module Checkout
    class Process
      attr_reader :deps

      def initialize(dependencies)
        @deps = dependencies
      end

      def process(step, state)
        step.process(state)
      rescue Error => e
        deps.logger.error(e)
        raise e
      end
    end
  end
end