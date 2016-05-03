module MarketTown
  module Checkout
    module Spree
      class Finish
        def cart_step(state)
          state[:order].update!(state: :address)
        end
      end
    end
  end
end
