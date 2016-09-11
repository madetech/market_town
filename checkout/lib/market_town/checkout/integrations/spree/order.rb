module MarketTown
  module Checkout
    module Spree
      class Order
        def has_line_items?(state)
          state[:order].line_items.any?
        end

        def set_addresses(state)
          state[:order].build_bill_address(transform_address(state[:billing_address]))
          state[:order].build_ship_address(transform_address(state[:delivery_address]))
          nil
        end

        private

        def transform_address(address)
          AddressTransformation.new.transform(address)
        end
      end
    end
  end
end
