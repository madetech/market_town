module MarketTown
  module Checkout
    class Step
      def self.steps(*steps)
        if steps.empty?
          @steps
        else
          @steps = steps
        end
      end

      attr_reader :meta, :deps

      def initialize(dependencies = Dependencies.new)
        @meta = { name: name_from_class }
        @deps = dependencies
      end

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
        deps.logger.warn("MissingDependency so #{warning.to_s.split('_').join(' ')}")
        state.merge(warnings: state.fetch(:warnings, []).push(warning))
      end
    end
  end
end
