module Checkout
  class Step
    attr_reader :meta

    def initialize
      @meta = { name: :complete }
    end

    def [](meta_key)
      meta.fetch(meta_key)
    end

    private

    def update_step(state)
      state.merge(step: self[:name])
    end
  end
end
