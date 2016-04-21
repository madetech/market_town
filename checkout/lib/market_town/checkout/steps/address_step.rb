module MarketTown
  module Checkout
    class AddressStep < Step
      class InvalidAddressError < Error; end
      class CannotFulfilAddressError < Error; end
      class CannotProposeShipmentsError < Error; end

      steps :validate_billing_address,
            :validate_delivery_address,
            :ensure_delivery,
            :store_addresses,
            :propose_shipments

      private

      def validate_billing_address(state)
        validate_address(:billing, state[:billing_address])
      end

      def validate_delivery_address(state)
        validate_address(:delivery, state[:delivery_address])
      end

      def ensure_delivery(state)
        unless deps.fulfilments.can_fulfil_address?(state[:delivery_address])
          raise CannotFulfilAddressError.new(state[:delivery_address])
        end
      rescue MissingDependency
        add_warning(state, :cannot_ensure_delivery)
      end

      def store_addresses(state)
        deps.address_storage.store(state)
      end

      def propose_shipments(state)
        deps.fulfilments.propose_shipments(state[:delivery_address])
      rescue MissingDependency
        add_warning(state, :cannot_propose_shipments)
      rescue RuntimeError => e
        raise CannotProposeShipmentsError.new(e)
      end

      def validate_address(type, address)
        Address.validate!(address)
      rescue Address::InvalidError => e
        raise InvalidAddressError.new({ type: type }.merge(e.data))
      end
    end
  end
end
