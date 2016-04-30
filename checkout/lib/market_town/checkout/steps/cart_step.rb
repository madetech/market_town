module MarketTown
  module Checkout
    # The place where a checkout process begins. This step represents the
    # finalisation of a cart before the checkout process.
    #
    # Dependencies:
    #  - order#has_line_items?
    #  - address_storage#load_default
    #  - promotions#apply_cart_promotions
    #  - finish#cart_step
    #
    class CartStep < Step
      class NoLineItemsError < Error; end

      steps :ensure_line_items,
            :load_default_addresses,
            :finish_cart_step

      protected

      # @raise [NoLineItemsError] when no line items on order
      #
      def ensure_line_items(state)
        unless deps.order.has_line_items?(state)
          raise NoLineItemsError.new(state)
        end
      end

      # Tries to load default addresses
      #
      def load_default_addresses(state)
        deps.address_storage.load_default(state)
      rescue MissingDependency
        add_dependency_missing_warning(state, :cannot_load_default_addresses)
      end

      # Tries to apply cart promotions
      #
      def apply_cart_promotions(state)
      end

      # Finishes cart step
      #
      def finish_cart_step(state)
        deps.finish.cart_step(state)
      end
    end
  end
end
