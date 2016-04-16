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

    def initialize(dependencies = {})
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

    def update_step(state)
      state.merge(step: self[:name])
    end
  end
end
