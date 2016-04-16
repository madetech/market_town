module MarketTown
  module Checkout
    class AddressStep < Step
      class InvalidAddressError < RuntimeError; end

      steps :validate_billing_address,
            :validate_delivery_address

      private

      def validate_billing_address(state)
        validate_address(:billing, state[:billing_address])
      end

      def validate_delivery_address(state)
        validate_address(:delivery, state[:delivery_address])
      end

      def validate_address(type, address)
        Address.validate!(address)
      rescue Checkout::Address::InvalidError => e
        message = { type: type }.merge(e.data)
        raise Checkout::AddressStep::InvalidAddressError.new(message)
      end
    end
  end
end
