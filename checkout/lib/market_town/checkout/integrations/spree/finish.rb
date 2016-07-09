module MarketTown
  module Checkout
    module Spree
      class Finish
        def cart_step(state)
          state[:order].update_attributes!(state: :address)
        end

        def address_step(state)
          state[:order].user.save! if state[:order].user.changed?
          state[:order].update_attributes!(state: :delivery)
        end
      end
    end
  end
end
