module MarketTown
  module Checkout
    module Contracts
      class Payments
        def valid_method?(state)
          true
        end

        def begin_transaction(state)
        end

        def processing?(state)
          true
        end

        def complete_transaction(state)
        end

        def persist_method(state)
        end

        shared_examples_for 'Payments' do
          context '#valid_method?' do
            subject { described_class.new.valid_method?({}) }
            it_behaves_like 'a boolean query method'
          end

          context '#processing?' do
            subject { described_class.new.processing?({}) }
            it_behaves_like 'a boolean query method'
          end

          context '#propose_shipments' do
            subject { described_class.new.begin_transaction({}) }
            it_behaves_like 'a command method'
          end

          context '#apply_shipment_costs' do
            subject { described_class.new.complete_transaction({}) }
            it_behaves_like 'a command method'
          end

          context '#fulfil' do
            subject { described_class.new.persist_method({}) }
            it_behaves_like 'a command method'
          end
        end
      end
    end
  end
end
