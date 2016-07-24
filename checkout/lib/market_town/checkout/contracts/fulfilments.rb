module MarketTown
  module Checkout
    module Contracts
      class Fulfilments
        def propose_shipments(state)
        end

        def can_fulfil_shipments?(state)
          true
        end

        def apply_shipment_costs(state)
        end

        def fulfil(state)
        end

        shared_examples_for 'Fulfilments' do
          context '#propose_shipments' do
            subject { described_class.new.propose_shipments(state) }
            it_behaves_like 'a command method'
          end

          context '#can_fulfil_shipments?' do
            subject { described_class.new.can_fulfil_shipments?(state) }
            it_behaves_like 'a boolean query method'
          end

          context '#apply_shipment_costs' do
            subject { described_class.new.apply_shipment_costs(state) }
            it_behaves_like 'a command method'
          end

          context '#fulfil' do
            subject { described_class.new.fulfil(state) }
            it_behaves_like 'a command method'
          end
        end
      end
    end
  end
end
