module MarketTown
  module Checkout
    module Contracts
      class AddressStorage
        # @param [Hash] state
        # @option state [Hash] :order object by which to find addresses
        #
        def load_default(state)
          {}
        end

        # @param [Hash] state
        # @option state [Hash] :billing_address as per {Address.validate!}
        # @option state [Hash] :delivery_address as per {Address.validate!}
        #
        def store(state)
        end

        shared_examples_for 'AddressStorage' do
          context '#load_default' do
            subject { described_class.new.load_default({}) }
            it_behaves_like 'a query method'
          end

          context '#store' do
            subject { described_class.new.store({}) }
            it_behaves_like 'a command method'
          end
        end
      end
    end
  end
end
