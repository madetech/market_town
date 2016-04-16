describe Checkout::CompleteStep do
  let(:notifications) { double(notify: nil) }
  let(:deps) { double(notifications: notifications) }
  let(:steps) { Checkout::CompleteStep.new(deps) }

  context 'when processing checkout' do
    context 'and order incomplete' do
      subject { steps.process(last_step: :new) }
      it { is_expected.to include(last_step: :complete) }
      it { is_expected.to include(:completed_at) }

      context 'then notifications' do
        subject { notifications }
        before { steps.process(last_step: :new) }
        it { is_expected.to have_received(:notify).with(:order_complete, Hash) }
      end
    end

    context 'and order already completed' do
      subject { steps.process(last_step: :complete) }
      it { expect { subject }.to raise_error(Checkout::CompleteStep::AlreadyCompleteError) }
    end
  end
end
