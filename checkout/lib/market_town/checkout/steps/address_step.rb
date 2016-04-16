module MarketTown
  module Checkout
    class AddressStep < Step
      class InvalidAddressError < RuntimeError; end

      steps :validate_billing_address,
            :validate_delivery_address

      private

      def validate_billing_address(state)
        Address.validate!(:billing, state[:billing_address])
      rescue Checkout::Address::InvalidError => e
        raise Checkout::AddressStep::InvalidAddressError.new(e.message)
      end

      def validate_delivery_address(state)
        Address.validate!(:delivery, state[:delivery_address])
      rescue Checkout::Address::InvalidError => e
        raise Checkout::AddressStep::InvalidAddressError.new(e.message)
      end
    end
  end
end
