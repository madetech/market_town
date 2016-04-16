module Checkout
  class CompleteStep < Step
    steps :ensure_incomplete,
          :set_completed_at,
          :update_step

    private

    def ensure_incomplete(state)
      if self[:name] == state[:step]
        raise AlreadyCompleteError.new(state)
      end
    end

    def set_completed_at(state)
      state.merge(completed_at: Time.now)
    end

    class AlreadyCompleteError < RuntimeError; end
  end
end
