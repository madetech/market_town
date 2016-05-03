module MarketTown
  module Checkout
    module Contracts
      class Tax
        def apply_order_tax(state)
        end

        shared_examples_for 'Tax' do
          context '#apply_order_tax' do
            subject { described_class.new.apply_order_tax({}) }
            it_behaves_like 'a command method'
          end
        end
      end
    end
  end
end
