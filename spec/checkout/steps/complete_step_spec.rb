describe Checkout::CompleteStep do
  context 'when processing checkout' do
    context 'and order incomplete' do
      subject { Checkout::CompleteStep.new.process({ step: :new }) }
      it { is_expected.to include(:completed_at) }
    end

    context 'and order already completed' do
      subject { Checkout::CompleteStep.new.process({ step: :complete }) }
      it { expect { subject }.to raise_error(Checkout::CompleteStep::AlreadyCompleteError) }
    end
  end
end
