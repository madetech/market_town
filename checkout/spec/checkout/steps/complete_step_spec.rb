module MarketTown::Checkout
  describe CompleteStep do
    let(:notifications) { double(notify: nil) }
    let(:complete_step) { double(complete?: false, complete: nil) }

    let(:deps) { Dependencies.new(notifications: notifications,
                                  complete_step: complete_step,
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
        let(:complete_step) { double(complete?: true, complete: nil) }

        subject { steps.process({}) }

        it { expect { subject }.to raise_error(CompleteStep::AlreadyCompleteError) }
      end
    end

    context 'when completing complete step' do
      before { steps.process({}) }

      subject { complete_step }

      it { is_expected.to have_received(:complete) }
    end
  end
end
