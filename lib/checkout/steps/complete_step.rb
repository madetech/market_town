module Checkout
  class CompleteStep < Step
    steps :ensure_incomplete,
          :set_completed_at,
          :send_order_complete_notice,
          :update_last_step

    private

    def ensure_incomplete(state)
      if self[:name] == state[:last_step]
        raise AlreadyCompleteError.new(state)
      end
    end

    def set_completed_at(state)
      state.merge(completed_at: Time.now)
    end

    def send_order_complete_notice(state)
      deps.notifications.notify(:order_complete, state)
    end

    class AlreadyCompleteError < RuntimeError; end
  end
end
