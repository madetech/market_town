module MarketTown
  module Checkout
    class DeliveryStep < Step
      class InvalidDeliveryAddressError < RuntimeError; end
      class CannotFulfilShipmentsError < RuntimeError; end
      class CannotApplyPromotionsError < RuntimeError; end

      steps :ensure_delivery_address,
            :validate_shipments,
            :apply_delivery_promotions

      private

      def ensure_delivery_address(state)
        Address.validate!(state[:delivery_address])
      rescue Address::InvalidError => e
        raise InvalidDeliveryAddressError.new(e.data)
      end

      def validate_shipments(state)
        unless deps.fulfilments.can_fulfil_shipments?(state[:shipments])
          raise CannotFulfilShipmentsError.new(state[:shipments])
        end
      rescue MissingDependency
        add_warning(state, :cannot_validate_shipments)
      end

      def apply_delivery_promotions(state)
        deps.promotions.apply_delivery_promotions(state)
      rescue MissingDependency
        add_warning(state, :cannot_apply_delivery_promotions)
      rescue RuntimeError => e
        raise CannotApplyPromotionsError.new(e)
      end
    end
  end
end
