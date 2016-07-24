module MarketTown
  module Checkout
    module Spree
      class Container < Dependencies
        def finish
          Finish.new
        end

        def fulfilments
          Fulfilments.new
        end

        def order
          Order.new
        end

        def user_address_storage
          UserAddressStorage.new
        end
      end
    end
  end
end
