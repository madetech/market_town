module MarketTown
  module Checkout
    module Contracts
      class AddressStorage
        # @param [Hash] state
        # @option state [Hash] :order object by which to find addresses
        #
        def load_user_defaults(state)
          {}
        end

        # @param [Hash] state
        # @option state [Hash] :billing_address as per {Address.validate!}
        #
        def store_user_billing_address(state)
        end

        # @param [Hash] state
        # @option state [Hash] :delivery_address as per {Address.validate!}
        #
        def store_user_delivery_address(state)
        end

        shared_examples_for 'AddressStorage' do
          context '#load_user_defaults' do
            subject { described_class.new.load_user_defaults({}) }
            it_behaves_like 'a query method'
          end

          context '#store_user_billing_address' do
            subject { described_class.new.store_user_billing_address({}) }
            it_behaves_like 'a command method'
          end

          context '#store_user_delivery_address' do
            subject { described_class.new.store_user_delivery_address({}) }
            it_behaves_like 'a command method'
          end
        end
      end
    end
  end
end
