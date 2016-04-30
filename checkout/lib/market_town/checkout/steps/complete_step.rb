module MarketTown
  module Checkout
    # Handles completion of checkout. All payments and options should have
    # already been completed by this point. The purpose of this step is to
    # request the fulfilment of the order and notify the customer.
    #
    # Dependencies:
    #
    # - finish#complete_step_finished?
    # - fulfilments#fulfil
    # - notifications#notify
    # - finish#complete_step
    #
    class CompleteStep < Step
      class AlreadyCompleteError < Error; end

      steps :ensure_incomplete,
            :fulfil_order,
            :send_order_complete_notice,
            :finish_complete_step

      protected

      # @raise [AlreadyCompleteError]
      #
      def ensure_incomplete(state)
        if deps.finish.complete_step_finished?(state)
          raise AlreadyCompleteError.new(state)
        end
      end

      # Tries to fulfil order
      #
      def fulfil_order(state)
        deps.fulfilments.fulfil(state)
      rescue MissingDependency
        add_dependency_missing_warning(state, :cannot_fulfil_order)
      end

      # Tries to send notifications about order complete
      #
      def send_order_complete_notice(state)
        deps.notifications.notify(:order_complete, state)
      rescue MissingDependency
        add_dependency_missing_warning(state, :cannot_send_order_complete_notice)
      end

      # Finishes complete step
      #
      def finish_complete_step(state)
        deps.finish.complete_step(state)
      end
    end
  end
end
