module MarketTown
  module Checkout
    module Contracts
      class Payments
        def valid_method?(state)
        end

        def begin_transaction(state)
        end

        def processing?(state)
        end

        def complete_transaction(state)
        end

        def persist_method(state)
        end
      end
    end
  end
end
