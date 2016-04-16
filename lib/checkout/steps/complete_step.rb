module Checkout
  class CompleteStep < Step
    steps :ensure_incomplete,
          :update_step

    private

    def ensure_incomplete(state)
      if self[:name] == state[:step]
        raise AlreadyCompleteError.new(state)
      end
    end

    class AlreadyCompleteError < RuntimeError; end
  end
end
