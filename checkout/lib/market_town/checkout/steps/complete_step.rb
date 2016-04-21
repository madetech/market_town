module MarketTown
  module Checkout
    class CompleteStep < Step
      class AlreadyCompleteError < Error; end

      steps :ensure_incomplete,
            :send_order_complete_notice,
            :complete_complete_step

      protected

      def ensure_incomplete(state)
        if deps.complete_step.complete?(state)
          raise AlreadyCompleteError.new(state)
        end
      end

      def send_order_complete_notice(state)
        deps.notifications.notify(:order_complete, state)
      rescue MissingDependency
        add_warning(state, :cannot_send_order_complete_notice)
      end

      def complete_complete_step(state)
        deps.complete_step.complete(state)
      end
    end
  end
end
