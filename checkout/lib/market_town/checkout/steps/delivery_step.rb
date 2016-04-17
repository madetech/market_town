module MarketTown
  module Checkout
    class DeliveryStep < Step
      class InvalidDeliveryAddress < RuntimeError; end
      class CannotFulfilShipmentsError < RuntimeError; end

      steps :ensure_delivery_address,
            :validate_shipments

      private

      def ensure_delivery_address(state)
        Address.validate!(state[:delivery_address])
      rescue Address::InvalidError => e
        raise InvalidDeliveryAddress.new(e.data)
      end

      def validate_shipments(state)
        unless deps.fulfilment.can_fulfil_shipments?(state[:shipments])
          raise CannotFulfilShipmentsError.new(state[:shipments])
        end
      rescue MissingDependency
        add_warning(state, :cannot_validate_shipments)
      end
    end
  end
end
