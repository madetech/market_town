module MarketTown
  module Checkout
    module Spree
      class Finish
        def cart_step(state)
          state[:order].update_attributes!(state: :address)
        end

        def address_step(state)
          state[:order].build_bill_address(transform_address(state[:billing_address]))
          state[:order].build_ship_address(transform_address(state[:delivery_address]))
          state[:order].update_attributes!(state: :delivery)
        end

        private

        def transform_address(address)
          AddressTransformation.new.transform(address)
        end
      end
    end
  end
end
