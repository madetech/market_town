module MarketTown
  module Checkout
    module Contracts
      class Finish
        def cart_step(state)
        end

        def address_step(state)
        end

        def delivery_step(state)
        end

        def begin_payment_step(state)
        end

        def complete_step_finished?(state)
          true
        end

        def complete_step(state)
        end

        shared_examples_for 'Finish' do
          context '#complete_step_finished?' do
            subject { described_class.new.complete_step_finished?({}) }
            it_behaves_like 'a boolean query method'
          end

          context '#cart_step' do
            subject { described_class.new.cart_step({}) }
            it_behaves_like 'a command method'
          end

          context '#address_step' do
            subject { described_class.new.address_step({}) }
            it_behaves_like 'a command method'
          end

          context '#delivery_step' do
            subject { described_class.new.delivery_step({}) }
            it_behaves_like 'a command method'
          end

          context '#begin_payment_step' do
            subject { described_class.new.begin_payment_step({}) }
            it_behaves_like 'a command method'
          end

          context '#complete_step' do
            subject { described_class.new.complete_step({}) }
            it_behaves_like 'a command method'
          end
        end
      end
    end
  end
end
