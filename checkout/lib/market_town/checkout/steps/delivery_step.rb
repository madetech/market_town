module MarketTown
  module Checkout
    # Handles delivery method and application of delivery promotions.
    #
    # Dependencies:
    #
    # - {Contracts::Promotions#apply_delivery_promotions}
    # - {Contracts::Finish#delivery_step}
    #
    class DeliveryStep < Step
      class InvalidDeliveryAddressError < Error; end

      steps :validate_delivery_address,
            :apply_delivery_promotions,
            :load_default_payment_method,
            :finish_delivery_step

      protected

      # @raise [InvalidDeliveryAddressError]
      #
      def validate_delivery_address(state)
        Address.validate!(state[:delivery_address])
      rescue Address::InvalidError => e
        raise InvalidDeliveryAddressError.new(e.data)
      end

      # Tries to apply delivery promotions
      #
      def apply_delivery_promotions(state)
        deps.promotions.apply_delivery_promotions(state)
      rescue MissingDependency
        add_dependency_missing_warning(state, :cannot_apply_delivery_promotions)
      end

      # Tries to load default payment method
      #
      def load_default_payment_method(state)
        deps.payments.load_default_payment_method(state)
      rescue MissingDependency
        add_dependency_missing_warning(state, :cannot_load_default_payment_method)
      end

      # Finish delivery step
      #
      def finish_delivery_step(state)
        deps.finish.delivery_step(state)
      end
    end
  end
end
