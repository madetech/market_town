module MarketTown
  module Checkout
    class ProcessStep
      attr_reader :deps

      def initialize(dependencies)
        @deps = dependencies
      end

      def process(step, state)
        step.process(state)
      rescue Error => e
        deps.logger.error(e)
        raise e
      rescue => e
        binding.pry
      end
    end
  end
end
