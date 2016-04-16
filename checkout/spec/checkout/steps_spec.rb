module MarketTown::Checkout
  describe Steps do
    let(:steps) { Steps.new(steps) }

    context 'when checkout has one step' do
      let(:steps) { [double(:step)] }
      subject { steps.count }
      it { is_expected.to eq(1) }
    end

    context 'when checkout has two steps' do
      let(:steps) { [double(:step), double(:step)] }
      subject { steps.count }
      it { is_expected.to eq(2) }
    end
  end
end
