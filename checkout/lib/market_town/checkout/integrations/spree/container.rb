module MarketTown
  module Checkout
    module Spree
      class Container < Dependencies
        def order
          Order.new
        end

        def address_storage
          AddressStorage.new
        end

        def finish
          Finish.new
        end
      end
    end
  end
end
