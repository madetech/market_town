module MarketTown::Checkout
  describe ProcessStep do
    context 'when processing single step checkout' do
      let(:step) { double(process: { step: :step_just_completed}) }
      subject { ProcessStep.new.process(step, state) }

      context 'and checkout state is empty' do
        let(:state) { {} }
        it { is_expected.to include(step: :step_just_completed) }
      end

      context 'and checkout already at step' do
        let(:state) { { step: :step_just_completed } }
        it { is_expected.to include(step: :step_just_completed) }
      end
    end
  end
end
