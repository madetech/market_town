module MarketTown
  module Checkout
    module Solidus
      class Container < Spree::Container
        def order
          Spree::Order.new
        end

        def finish
          Spree::Finish.new
        end
      end
    end
  end
end
