module MarketTown
  module Checkout
    class CompleteStep < Step
      steps :ensure_incomplete,
            :set_completed_at,
            :send_order_complete_notice

      private

      def ensure_incomplete(state)
        if state.has_key?(:completed_at)
          raise AlreadyCompleteError.new(state)
        end
      end

      def set_completed_at(state)
        state.merge(completed_at: Time.now)
      end

      def send_order_complete_notice(state)
        deps.notifications.notify(:order_complete, state)
      rescue MissingDependency
        add_warning(state, :unsent_order_complete_notice)
      end

      class AlreadyCompleteError < RuntimeError; end
    end
  end
end
