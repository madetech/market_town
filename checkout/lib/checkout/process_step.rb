module Checkout
  class ProcessStep
    def process(step, state)
      step.process(state)
    end
  end
end
