describe Checkout::CompleteStep do
  context 'when processing already completed step' do
    subject { Checkout::CompleteStep.new.process({ step: :complete }) }
    it { expect { subject }.to raise_error(Checkout::CompleteStep::AlreadyCompleteError) }
  end
end
