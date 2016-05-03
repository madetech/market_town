module MarketTown
  module Checkout
    module Contracts
      class AddressStorage
        # @param [Hash] state
        # @option state [Hash] :order object by which to find addresses
        #
        def load_default(state)
        end

        # @param [Hash] state
        # @option state [Hash] :billing_address as per {Address.validate!}
        # @option state [Hash] :delivery_address as per {Address.validate!}
        #
        def store(state)
        end
      end
    end
  end
end
