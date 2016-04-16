module MarketTown
  module Checkout
    class DeliveryStep < Step
      class InvalidDeliveryAddress < RuntimeError; end

      steps :ensure_delivery_address

      private

      def ensure_delivery_address(state)
        Address.validate!(state[:delivery_address])
      rescue Address::InvalidError => e
        raise InvalidDeliveryAddress.new(e.data)
      end
    end
  end
end
