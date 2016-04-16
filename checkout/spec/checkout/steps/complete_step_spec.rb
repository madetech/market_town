module MarketTown::Checkout
  describe CompleteStep do
    let(:notifications) { double(notify: nil) }
    let(:deps) { Dependencies.new(notifications: notifications, logger: double(warn: nil)) }
    let(:steps) { CompleteStep.new(deps) }

    context 'when completing checkout' do
      context 'and order incomplete' do
        subject { steps.process({}) }

        it { is_expected.to include(:completed_at) }

        context 'then notifications' do
          subject { notifications }
          before { steps.process({}) }
          it { is_expected.to have_received(:notify).with(:order_complete, Hash) }
        end

        context 'and no notifications handled' do
          let(:notifications) { nil }
          it { is_expected.to include(:warnings) }
        end
      end

      context 'and order already completed' do
        subject { steps.process(completed_at: Time.now) }
        it { expect { subject }.to raise_error(CompleteStep::AlreadyCompleteError) }
      end
    end
  end
end
