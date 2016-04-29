module MarketTown
  module Checkout
    class CartStep < Step
      class NoLineItemsError < Error; end

      steps :ensure_line_items,
            :load_default_addresses,
            :finish_cart_step

      protected

      def ensure_line_items(state)
        unless deps.order.has_line_items?(state)
          raise NoLineItemsError.new(state)
        end
      end

      def load_default_addresses(state)
        deps.address_storage.load_default(state)
      rescue MissingDependency
        add_dependency_missing_warning(state, :cannot_load_default_addresses)
      end

      def finish_cart_step(state)
        deps.finish.cart_step(state)
      end
    end
  end
end
