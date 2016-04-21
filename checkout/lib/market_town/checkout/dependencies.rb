module MarketTown
  module Checkout
    # A dependency container for injecting custom behaviour into {Checkout} and
    # subsequently {Step}.
    #
    # The purpose of {Checkout} is to provide the logic for orchestrating the
    # checkout process. The actual implementation needs to be injected at
    # runtime via {Dependencies} or an object like it.
    #
    # ## Using {Dependencies}
    #
    # Since {Dependencies} extends the ruby Hash object you can treat it as
    # such. We provide {#method_missing} to provide a way of accessing keys
    # of the hash with methods.
    #
    # First let's create a dependency for sending notifications.
    #
    # ``` ruby
    # class Notifications
    #   def notify(notification, data)
    #     puts :notification, JSON.dump(data)
    #   end
    # end
    # ```
    #
    # Now we can create our container and use it:
    #
    # ``` ruby
    # container = MarketTown::Checkout::Dependencies.new(notifications: Notifications.new)
    #
    # container.notifications.notify(:order_complete, { order_id: 1 })
    # ```
    #
    # You don't actually need to use the container yourself though. The point
    # of the container is to inject behaviour into a checkout step. You would
    # usually use it like so:
    #
    # ``` ruby
    # container = MarketTown::Checkout::Dependencies.new(notifications: Notifications.new)
    #
    # MarketTown::Checkout.process_step(step: :complete,
    #                                   dependencies: container,
    #                                   state: { order: order })
    # ```
    #
    # ## Extending {Dependencies}
    #
    # You can extend {Dependencies} instead of passing a Hash into it's
    # constructor:
    #
    # ``` ruby
    # class AppContainer < MarketTown::Checkout::Dependencies
    #   def notifications
    #     Notifications.new
    #   end
    # end
    # ```
    #
    # You can define an application wide container like this or you could
    # setup different containers for each step in your checkout.
    #
    # ## Using your own container
    #
    # As long as you provide an object that provides the dependencies
    # each step needs you do not actually need to extend {Dependencies} at all.
    #
    # ``` ruby
    # class AppContainer
    #   def notifications
    #     Notifications.new
    #   end
    # end
    # ```
    #
    class Dependencies < Hash
      def initialize(deps = {})
        merge!(deps.delete_if { |k, v| v.nil? })
      end

      # Used to fetch a dependency
      #
      # @example
      #   container.complete_step.delivery(state)
      #
      # @raise [MissingDependency] when dependency is not defined
      #
      def method_missing(method)
        fetch(method)
      rescue KeyError
        raise MissingDependency.new(method)
      end

      # Uses built-in ruby Logger if not provided
      #
      # @return [Logger or similar]
      #
      def logger
        super
      rescue MissingDependency
        require 'logger'
        Logger.new(STDOUT)
      end
    end
  end
end
