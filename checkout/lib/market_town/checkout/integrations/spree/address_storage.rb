module MarketTown
  module Checkout
    module Spree
      class AddressStorage
        def load_default(state)
          if state[:order].user_id?
            state[:order].bill_address = state[:order].user.bill_address.try(:clone)
            state[:order].ship_address = state[:order].user.ship_address.try(:clone)
            nil
          end
        end

        def set_order_addresses(state)
          state[:order].build_bill_address(transform_address(state[:billing_address]))
          state[:order].build_ship_address(transform_address(state[:delivery_address]))
          nil
        end

        def store_user_billing_address(state)
          if state[:order].user_id?
            state[:order].user.bill_address_attributes = transform_address(state[:billing_address])
            state[:order].user.save!
            nil
          end
        end

        def store_user_delivery_address(state)
          if state[:order].user_id?
            state[:order].user.ship_address_attributes = transform_address(state[:delivery_address])
            state[:order].user.save!
            nil
          end
        end

        private

        def transform_address(address)
          AddressTransformation.new.transform(address)
        end
      end
    end
  end
end
