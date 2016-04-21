module MarketTown
  module Checkout
    class CompleteStep < Step
      class AlreadyCompleteError < Error; end

      steps :ensure_incomplete,
            :set_completed_at,
            :send_order_complete_notice

      private

      def ensure_incomplete(state)
        if deps.complete_step.complete?(state)
          raise AlreadyCompleteError.new(state)
        end
      end

      def set_completed_at(state)
        state.merge(completed_at: Time.now)
      end

      def send_order_complete_notice(state)
        deps.notifications.notify(:order_complete, state)
      rescue MissingDependency
        add_warning(state, :cannot_send_order_complete_notice)
      end
    end
  end
end
