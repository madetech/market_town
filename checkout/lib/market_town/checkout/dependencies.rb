module MarketTown
  module Checkout
    class Dependencies < Hash
      def initialize(deps = {})
        merge!(deps.delete_if { |k, v| v.nil? })
      end

      def method_missing(method)
        fetch(method)
      rescue KeyError
        raise MissingDependency.new(method)
      end

      def logger
        super
      rescue MissingDependency
        require 'logger'
        Logger.new(STDOUT)
      end
    end

    class MissingDependency < RuntimeError; end
  end
end
