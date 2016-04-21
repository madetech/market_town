module MarketTown
  module Checkout
    class DeliveryStep < Step
      class InvalidDeliveryAddressError < Error; end
      class CannotFulfilShipmentsError < Error; end

      steps :validate_delivery_address,
            :validate_shipments,
            :apply_delivery_promotions,
            :complete_delivery_step

      protected

      def validate_delivery_address(state)
        Address.validate!(state[:delivery_address])
      rescue Address::InvalidError => e
        raise InvalidDeliveryAddressError.new(e.data)
      end

      def validate_shipments(state)
        unless deps.fulfilments.can_fulfil_shipments?(state)
          raise CannotFulfilShipmentsError.new(state[:shipments])
        end
      rescue MissingDependency
        add_warning(state, :cannot_validate_shipments)
      end

      def apply_delivery_promotions(state)
        deps.promotions.apply_delivery_promotions(state)
      rescue MissingDependency
        add_warning(state, :cannot_apply_delivery_promotions)
      end

      def complete_delivery_step(state)
        deps.complete_step.delivery(state)
      end
    end
  end
end
