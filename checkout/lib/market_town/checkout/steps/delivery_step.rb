module MarketTown
  module Checkout
    # Handles delivery method and application of delivery promotions.
    #
    # Dependencies:
    #  - fulfilments#can_fulfil_shipments?
    #  - promotions#apply_delivery_promotions
    #  - finish#delivery_step
    #
    class DeliveryStep < Step
      class InvalidDeliveryAddressError < Error; end
      class CannotFulfilShipmentsError < Error; end

      steps :validate_delivery_address,
            :validate_shipments,
            :apply_delivery_promotions,
            :finish_delivery_step

      protected

      # @raise [InvalidDeliveryAddressError]
      #
      def validate_delivery_address(state)
        Address.validate!(state[:delivery_address])
      rescue Address::InvalidError => e
        raise InvalidDeliveryAddressError.new(e.data)
      end

      # Tries to validate shipments
      #
      # @raise [CannotFulfilShipmentsError]
      #
      def validate_shipments(state)
        unless deps.fulfilments.can_fulfil_shipments?(state)
          raise CannotFulfilShipmentsError.new(state[:shipments])
        end
      rescue MissingDependency
        add_dependency_missing_warning(state, :cannot_validate_shipments)
      end

      # Tries to apply delivery promotions
      #
      def apply_delivery_promotions(state)
        deps.promotions.apply_delivery_promotions(state)
      rescue MissingDependency
        add_dependency_missing_warning(state, :cannot_apply_delivery_promotions)
      end

      # Finish delivery step
      #
      def finish_delivery_step(state)
        deps.finish.delivery_step(state)
      end
    end
  end
end
