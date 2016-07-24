module MarketTown
  module Checkout
    module Spree
      class Fulfilments
        def propose_shipments(state)
          state[:order].create_proposed_shipments
          nil
        end

        def can_fulfil_shipments?(state)
          true
        end

        def apply_shipment_costs(state)
        end

        def fulfil(state)
        end
      end
    end
  end
end
