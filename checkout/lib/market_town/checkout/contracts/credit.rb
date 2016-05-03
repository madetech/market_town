module MarketTown
  module Checkout
    module Contracts
      class Credit
        def apply_credit(state)
        end

        shared_examples_for 'Credit' do
          context '#apply_credit' do
            subject { described_class.new.apply_credit({}) }
            it_behaves_like 'a command method'
          end
        end
      end
    end
  end
end
