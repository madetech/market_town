module MarketTown
  module Checkout
    module Spree
      class Order
        def has_line_items?(state)
          state[:order].line_items.any?
        end
      end
    end
  end
end
