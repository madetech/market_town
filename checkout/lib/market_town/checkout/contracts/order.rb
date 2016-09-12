module MarketTown
  module Checkout
    module Contracts
      class Order
        def has_line_items?(state)
          true
        end

        def set_addresses(state)
        end

        shared_examples_for 'Order' do
          context '#has_line_items?' do
            subject { described_class.new.has_line_items?({}) }
            it_behaves_like 'a boolean query method'
          end

          context '#set_addresses' do
            subject { described_class.new.set_addresses({}) }
            it_behaves_like 'a command method'
          end
        end
      end
    end
  end
end
