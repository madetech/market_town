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
          context '#can_fulfil_shipments?' do
            subject { described_class.new.can_fulfil_shipments?({}) }
            it_behaves_like 'a boolean query method'
          end

          context '#propose_shipments' do
            subject { described_class.new.propose_shipments({}) }
            it_behaves_like 'a command method'
          end

          context '#apply_shipment_costs' do
            subject { described_class.new.apply_shipment_costs({}) }
            it_behaves_like 'a command method'
          end

          context '#fulfil' do
            subject { described_class.new.fulfil({}) }
            it_behaves_like 'a command method'
          end
        end
      end
    end
  end
end
