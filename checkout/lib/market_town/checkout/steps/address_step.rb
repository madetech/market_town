module MarketTown
  module Checkout
    class AddressStep < Step
      class InvalidAddressError < RuntimeError; end
      class CannotFulfilAddressError < RuntimeError; end

      steps :validate_billing_address,
            :validate_delivery_address,
            :ensure_can_deliver,
            :persist_billing_address,
            :persist_delivery_address

      private

      def validate_billing_address(state)
        validate_address(:billing, state[:billing_address])
      end

      def validate_delivery_address(state)
        validate_address(:delivery, state[:delivery_address])
      end

      def ensure_can_deliver(state)
        unless deps.fulfilment.can_fulfil_address?(state[:delivery_address])
          raise CannotFulfilAddressError.new(state[:delivery_address])
        end
      rescue MissingDependency
        add_warning(state, :could_not_ensure_delivery)
      end

      def persist_billing_address(state)
        if state[:billing_address][:save] == true
          deps.address_storage.store(address_type: :billing,
                                     address: state[:billing_address])
        end
      end

      def persist_delivery_address(state)
        if state[:delivery_address][:save] == true
          deps.address_storage.store(address_type: :delivery,
                                     address: state[:delivery_address])
        end
      end

      def validate_address(type, address)
        Address.validate!(address)
      rescue Address::InvalidError => e
        message = { type: type }.merge(e.data)
        raise InvalidAddressError.new(message)
      end
    end
  end
end
