module MarketTown::Checkout
  describe DeliveryStep do
    let(:fulfilments) { double(can_fulfil_shipments?: true) }
    let(:promotions) { double(apply_delivery_promotions: nil) }
    let(:payments) { double(load_default_payment_method: nil) }
    let(:finish) { double(delivery_step: nil) }

    let(:deps) do
      Dependencies.new(fulfilments: fulfilments,
                       promotions: promotions,
                       payments: payments,
                       finish: finish,
                       logger: double(warn: nil))
    end

    let(:step) { DeliveryStep.new(deps) }

    context 'when processing delivery method' do
      context 'and delivery address valid' do
        subject { step.process(delivery_address: mock_address) }

        it { is_expected.to include(:delivery_address) }
      end

      context 'and delivery address missing' do
        subject { step.process({}) }

        it { expect { subject }.to raise_error(DeliveryStep::InvalidDeliveryAddressError) }
      end

      context 'and delivery address invalid' do
        subject { step.process(delivery_address: mock_address.merge(name: nil)) }

        it { expect { subject }.to raise_error(DeliveryStep::InvalidDeliveryAddressError) }
      end
    end

    context 'when applying delivery promotions' do
      subject { step.process(delivery_address: mock_address) }

      context 'and can apply delivery promotions' do
        before do
          expect(promotions).to receive(:apply_delivery_promotions) do |state|
            state.merge(promotions: [:free_delivery])
          end
        end

        it { is_expected.to include(:promotions) }
      end

      context 'and promotions missing' do
        let(:promotions) { nil }

        it { is_expected.to include(:warnings) }
      end
    end

    context 'when loading default payment method' do
      subject { step.process(delivery_address: mock_address) }

      context 'and can load method' do
        before do
          expect(payments).to receive(:load_default_payment_method) do |state|
            state.merge(payment_method: :check)
          end
        end

        it { is_expected.to include(:payment_method) }
      end

      context 'and promotions missing' do
        let(:payments) { nil }

        it { is_expected.to include(:warnings) }
      end
    end

    context 'when completing step' do
      before { step.process(delivery_address: mock_address) }

      subject { finish }

      it { is_expected.to have_received(:delivery_step) }
    end
  end
end
