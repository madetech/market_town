module MarketTown
  module Checkout
    class Error < RuntimeError
      def errors
        p self.class.name
      end
    end
  end
end
