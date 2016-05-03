module MarketTown
  module Checkout
    module Contracts
      class Promotions
        def apply_cart_promotions(state)
        end

        def apply_delivery_promotions(state)
        end

        shared_examples_for 'Promotions' do
          context '#apply_cart_promotions' do
            subject { described_class.new.apply_cart_promotions({}) }
            it_behaves_like 'a command method'
          end

          context '#apply_delivery_promotions' do
            subject { described_class.new.apply_delivery_promotions({}) }
            it_behaves_like 'a command method'
          end
        end
      end
    end
  end
end
