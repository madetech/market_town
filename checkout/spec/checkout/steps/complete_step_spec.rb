module MarketTown::Checkout
  describe CompleteStep do
    let(:notifications) { double(notify: nil) }
    let(:finish) { double(complete_step_finished?: false, complete_step: nil) }

    let(:deps) { Dependencies.new(notifications: notifications,
                                  finish: finish,
                                  logger: double(warn: nil)) }

    let(:steps) { CompleteStep.new(deps) }

    context 'when completing checkout' do
      context 'and order incomplete' do
        subject { steps.process({}) }

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
        let(:finish) { double(complete_step_finished?: true, complete_step: nil) }

        subject { steps.process({}) }

        it { expect { subject }.to raise_error(CompleteStep::AlreadyCompleteError) }
      end
    end

    context 'when completing complete step' do
      before { steps.process({}) }

      subject { finish }

      it { is_expected.to have_received(:complete_step) }
    end
  end
end
