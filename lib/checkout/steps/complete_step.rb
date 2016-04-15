module Checkout
  class CompleteStep < Step
    def process(state)
      ensure_incomplete(state)
      update_step(state)
    end

    private

    def ensure_incomplete(state)
      if self[:name] == state[:step]
        raise AlreadyCompleteError.new(state)
      end
    end

    class AlreadyCompleteError < RuntimeError; end
  end
end
