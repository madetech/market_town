module MarketTown
  module Checkout
    # Processes steps given a set of dependencies
    #
    class Process
      attr_reader :deps

      # @param [Dependencies] dependencies
      #
      def initialize(dependencies)
        @deps = dependencies
      end

      # Delegates process to {Step} then rescues, logs and then reraises {Error}
      # if any occur
      #
      # @param [Step] step to be processed
      # @param [Hash] state
      #
      def process(step, state)
        step.process(state)
      rescue Error => e
        deps.logger.error(e)
        raise e
      end
    end
  end
end
