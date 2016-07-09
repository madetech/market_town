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
      end
    end
  end
end
