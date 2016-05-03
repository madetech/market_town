module MarketTown
  module Checkout
    # Handles end of payment. After ensuring payment is currently processing
    # {CompletePaymentStep} will complete the transaction and try to persist
    # the payment method.
    #
    # Dependencies:
    #
    # - {Contracts::Payments#processing?}
    # - {Contracts::Payments#complete_transaction}
    # - {Contracts::Payments#persist_method}
    #
    class CompletePaymentStep < Step
      step :ensure_processing_payment,
           :complete_transaction,
           :persist_payment_method,
           :finish_complete_payment_step

      protected

      def mark_payment_complete
      end

      def finish_complete_payment_step
      end
    end
  end
end
