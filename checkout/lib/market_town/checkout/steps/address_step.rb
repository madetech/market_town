module MarketTown
  module Checkout
    # Handles addresses by validating them and optionally storing them.
    #
    # Dependencies:
    #
    # - {Contracts::UserAddressStorage#store_billing_address}
    # - {Contracts::UserAddressStorage#store_delivery_address}
    # - {Contracts::Order#set_addresses}
    # - {Contracts::Fulfilments#propose_shipments}
    # - {Contracts::Fulfilments#can_fulfil_shipments?}
    # - {Contracts::Fulfilments#apply_shipment_costs}
    # - {Contracts::Finish#address_step}
    #
    class AddressStep < Step
      class InvalidAddressError < Error; end
      class CannotFulfilShipmentsError < Error; end

      steps :validate_billing_address,
            :use_billing_address_as_delivery_address,
            :validate_delivery_address,
            :set_order_addresses,
            :store_user_addresses,
            :propose_shipments,
            :validate_shipments,
            :apply_shipment_costs,
            :finish_address_step

      protected

      # @raise [InvalidAddressError]
      #
      def validate_billing_address(state)
        validate_address(:billing, state[:billing_address])
      end

      # Copies billing address into delivery address if requested
      #
      def use_billing_address_as_delivery_address(state)
        if state[:use_billing_address] == true
          state.merge(delivery_address: state[:billing_address])
        end
      end

      # @raise [InvalidAddressError]
      #
      def validate_delivery_address(state)
        validate_address(:delivery, state[:delivery_address])
      end

      # Sets addresses on order
      #
      def set_order_addresses(state)
        deps.order.set_addresses(state)
      rescue MissingDependency
        add_dependency_missing_warning(state, :cannot_set_order_addresses)
      end

      # Tries to store user addresses
      #
      def store_user_addresses(state)
        if state[:billing_address][:save]
          deps.user_address_storage.store_billing_address(state)
        end

        if state[:delivery_address][:save]
          deps.user_address_storage.store_delivery_address(state)
        end
      rescue MissingDependency
        add_dependency_missing_warning(state, :cannot_store_user_addresses)
      end

      # Tries to proposes shipments to delivery address ready to be confirmed at
      # delivery step.
      #
      def propose_shipments(state)
        deps.fulfilments.propose_shipments(state)
      rescue MissingDependency
        add_dependency_missing_warning(state, :cannot_propose_shipments)
      end

      # Tries to validate shipments
      #
      # @raise [CannotFulfilShipmentsError]
      #
      def validate_shipments(state)
        unless deps.fulfilments.can_fulfil_shipments?(state)
          raise CannotFulfilShipmentsError.new(state[:shipments])
        end
      rescue MissingDependency
        add_dependency_missing_warning(state, :cannot_validate_shipments)
      end

      # Tries to apply shipment costs to delivery address ready to be confirmed at
      # delivery step.
      #
      def apply_shipment_costs(state)
        deps.fulfilments.apply_shipment_costs(state)
      rescue MissingDependency
        add_dependency_missing_warning(state, :cannot_apply_shipment_costs)
      end

      # Finishes address step
      #
      def finish_address_step(state)
        deps.finish.address_step(state)
      end

      private

      def validate_address(type, address)
        Address.validate!(address)
      rescue Address::InvalidError => e
        raise InvalidAddressError.new({ type: type }.merge(e.data))
      end
    end
  end
end
