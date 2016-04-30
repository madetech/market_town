module MarketTown
  module Checkout
    # Handles addresses by validating them and optionally storing them.
    #
    # Dependencies:
    #
    # - fulfilments#can_fulfil_address?
    # - address_storage#store
    # - fulfilments#propose_shipments
    # - finish#address_step
    #
    class AddressStep < Step
      class InvalidAddressError < Error; end
      class CannotFulfilAddressError < Error; end

      steps :validate_billing_address,
            :use_billing_address_as_delivery_address,
            :validate_delivery_address,
            :ensure_delivery,
            :store_addresses,
            :propose_shipments,
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

      # Tries to ensure delivery can be made to address
      #
      # @raise [CannotFulfilAddressError]
      #
      def ensure_delivery(state)
        unless deps.fulfilments.can_fulfil_address?(state)
          raise CannotFulfilAddressError.new(state[:delivery_address])
        end
      rescue MissingDependency
        add_dependency_missing_warning(state, :cannot_ensure_delivery)
      end

      # Tries to store addresses
      #
      def store_addresses(state)
        deps.address_storage.store(state)
      rescue MissingDependency
        add_dependency_missing_warning(state, :cannot_store_address)
      end

      # Tries to proposes shipments to delivery address ready to be confirmed at
      # delivery step.
      #
      def propose_shipments(state)
        deps.fulfilments.propose_shipments(state)
      rescue MissingDependency
        add_dependency_missing_warning(state, :cannot_propose_shipments)
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
