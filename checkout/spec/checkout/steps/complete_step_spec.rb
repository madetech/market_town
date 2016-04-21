module MarketTown::Checkout
  describe CompleteStep do
    let(:fulfilments) { double(fulfil: nil) }
    let(:notifications) { double(notify: nil) }
    let(:finish) { double(complete_step_finished?: false, complete_step: nil) }

    let(:deps) { Dependencies.new(fulfilments: fulfilments,
                                  notifications: notifications,
                                  finish: finish,
                                  logger: double(warn: nil)) }

    let(:steps) { CompleteStep.new(deps) }

    context 'when completing checkout' do
      context 'and order incomplete' do
        subject { steps.process({}) }

        it { is_expected.to be_truthy }
      end

      context 'and order already completed' do
        let(:finish) { double(complete_step_finished?: true, complete_step: nil) }

        subject { steps.process({}) }

        it { expect { subject }.to raise_error(CompleteStep::AlreadyCompleteError) }
      end
    end

    context 'when fulfilling order' do
      subject { steps.process({}) }

      context 'and can fulfil' do
        context 'then fulfilments' do
          before { steps.process({}) }
          subject { fulfilments }
          it { is_expected.to have_received(:fulfil) }
        end
      end

      context 'and fulfilments missing' do
        let(:fulfilments) { nil }
        it { is_expected.to include(:warnings) }
      end
    end

    context 'when notifying complete order' do
      context 'and can notify' do
        context 'then notifications' do
          subject { notifications }
          before { steps.process({}) }
          it { is_expected.to have_received(:notify).with(:order_complete, Hash) }
        end
      end

      context 'and no notifications handled' do
        let(:notifications) { nil }
        subject { steps.process({}) }
        it { is_expected.to include(:warnings) }
      end
    end

    context 'when completing complete step' do
      before { steps.process({}) }

      subject { finish }

      it { is_expected.to have_received(:complete_step) }
    end
  end
end
