module MarketTown
  module Checkout
    class CompleteStep < Step
      class AlreadyCompleteError < Error; end

      steps :ensure_incomplete,
            :fulfil_order,
            :send_order_complete_notice,
            :finish_complete_step

      protected

      def ensure_incomplete(state)
        if deps.finish.complete_step_finished?(state)
          raise AlreadyCompleteError.new(state)
        end
      end

      def fulfil_order(state)
        deps.fulfilments.fulfil(state)
      rescue MissingDependency
        add_dependency_missing_warning(state, :cannot_fulfil_order)
      end

      def send_order_complete_notice(state)
        deps.notifications.notify(:order_complete, state)
      rescue MissingDependency
        add_dependency_missing_warning(state, :cannot_send_order_complete_notice)
      end

      def finish_complete_step(state)
        deps.finish.complete_step(state)
      end
    end
  end
end
