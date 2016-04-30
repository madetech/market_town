module MarketTown
  module Checkout
    # Extended by all steps provided by {MarketTown::Checkout}.
    #
    # ## Creating your own {Step}
    #
    # If you wish to create your own step then you can extend {Step} or you can
    # create a class that looks like step.
    #
    # ### Extending {Step}
    #
    # ``` ruby
    # class MyStep < MarketTown::Checkout::Step
    #   steps :a_step,
    #         :a_second_step
    #
    #   protected
    #
    #   def a_step(state)
    #   end
    #
    #   def a_second_step(state)
    #   end
    # end
    # ```
    #
    # ### Duck typing {Step}
    #
    # ``` ruby
    # class MyCustomStep
    #   def initialize(dependencies)
    #   end
    #
    #   def process(state)
    #   end
    # end
    # ```
    #
    # ## Extending an existing step
    #
    # You may want to alter the behaviour of a {Step}. You can do this quite
    # easily by extending the class.
    #
    # In the example below we'll replace the behaviour of {AddressStep} to
    # allow the use of delivery address as billing address instead of the
    # default behaviour that does the opposite.
    #
    # ``` ruby
    # class MyAddressStep < MarketTown::Checkout::AddressStep
    #   # Here we override the step order as defined in AddressStep. We
    #   # also replace #use_billing_address_as_delivery_address with
    #   # #use_delivery_address_as_billing_address.
    #   #
    #   steps :validate_delivery_address,
    #         :use_delivery_address_as_billing_address,
    #         :validate_billing_address,
    #         :ensure_delivery,
    #         :store_addresses,
    #         :propose_shipments,
    #         :finish_address_step
    #
    #   protected
    #
    #   def use_delivery_address_as_billing_address(state)
    #     if state[:use_delivery_address] == true
    #       state.merge(billing_address: state[:delivery_address])
    #     end
    #   end
    # end
    # ```
    #
    #
    class Step
      # Set steps for a subclass of {Step}.
      #
      # @example
      #   class MyStep < MarketTown::Checkout::Step
      #     steps :a_step,
      #           :a_second_step
      #
      #     protected
      #
      #     def a_step(state)
      #     end
      #
      #     def a_second_step(state)
      #     end
      #   end
      #
      def self.steps(*steps)
        if steps.empty?
          @steps
        else
          @steps = steps
        end
      end

      attr_reader :meta, :deps

      # Setup step meta object.
      #
      # @param [Dependencies]
      #
      def initialize(dependencies = Dependencies.new)
        @meta = { name: name_from_class }
        @deps = dependencies
      end

      # Process each sub-step that makes up step.
      #
      def process(state)
        self.class.steps.reduce(state) do |state, step|
          send(step, state) || state
        end
      end

      private

      def name_from_class
        self.class.name.split('::').last.sub('Step', '').downcase.to_sym
      end

      def [](meta_key)
        meta.fetch(meta_key)
      end

      def add_dependency_missing_warning(state, warning)
        deps.logger.warn("MissingDependency so #{warning.to_s.gsub('_', ' ')}")
        state.merge(warnings: state.fetch(:warnings, []).push(warning))
      end
    end
  end
end
