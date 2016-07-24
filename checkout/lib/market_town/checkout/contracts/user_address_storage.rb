module MarketTown
  module Checkout
    module Contracts
      class UserAddressStorage
        # @param [Hash] state
        # @option state [Hash] :order object by which to find addresses
        #
        def load_default_addresses(state)
        end

        # @param [Hash] state
        # @option state [Hash] :billing_address as per {Address.validate!}
        #
        def store_billing_address(state)
        end

        # @param [Hash] state
        # @option state [Hash] :delivery_address as per {Address.validate!}
        #
        def store_delivery_address(state)
        end

        shared_examples_for 'UserAddressStorage' do
          context '#load_default_addresses' do
            subject { described_class.new.load_default_addresses(state) }
            it_behaves_like 'a command method'
          end

          context '#store_billing_address' do
            subject { described_class.new.store_billing_address(state) }
            it_behaves_like 'a command method'
          end

          context '#store_delivery_address' do
            subject { described_class.new.store_delivery_address(state) }
            it_behaves_like 'a command method'
          end
        end
      end
    end
  end
end
