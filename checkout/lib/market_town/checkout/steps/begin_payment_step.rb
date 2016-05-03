module MarketTown
  module Checkout
    # Handles start of payment. Validates payment method before applying costs,
    # credit and sending a payment authorise or sale request to payment
    # gateway. Typically after this step a controller would either redirect to
    # a 3D secure page or straight to {CompletePaymentStep}.
    #
    # Dependencies:
    #
    # - payments#valid_method?
    # - payments#valid_method?
    # - fulfilments#apply_shipment_costs
    # - tax#apply_tax
    # - credit#apply_credit
    # - payments#begin_transaction
    # - finish#begin_payment_step
    #
    class BeginPaymentStep < Step
      step :validate_payment_method,
           :apply_shipment_costs,
           :apply_tax,
           :apply_credit,
           :process_payment,
           :finish_begin_payment_step

      protected

      def validate_payment_method
      end

      def charge_payment_method
      end

      def finish_begin_payment_step
      end
    end
  end
end
