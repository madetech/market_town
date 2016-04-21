module MarketTown::Checkout
  describe DeliveryStep do
    let(:fulfilments) { double(can_fulfil_shipments?: true) }
    let(:promotions) { double(apply_delivery_promotions: nil) }
    let(:complete_step) { double(delivery: nil) }

    let(:deps) { Dependencies.new(fulfilments: fulfilments,
                                  promotions: promotions,
                                  complete_step: complete_step,
                                  logger: double(warn: nil)) }

    let(:steps) { DeliveryStep.new(deps) }

    let(:mock_address) do
      { name: 'Luke Morton',
        address_1: '21 Cool St',
        locality: 'London',
        postal_code: 'N1 1PQ',
        country: 'GB' }
    end

    context 'when processing delivery method' do
      context 'and delivery address valid' do
        subject { steps.process(delivery_address: mock_address) }

        it { is_expected.to include(:delivery_address) }
      end

      context 'and delivery address missing' do
        subject { steps.process({}) }

        it { expect { subject }.to raise_error(DeliveryStep::InvalidDeliveryAddressError) }
      end

      context 'and delivery address invalid' do
        subject { steps.process(delivery_address: mock_address.merge(name: nil)) }

        it { expect { subject }.to raise_error(DeliveryStep::InvalidDeliveryAddressError) }
      end
    end

    context 'when validating fulfilments' do
      subject { steps.process(delivery_address: mock_address) }

      context 'and can fulfil' do
        context 'then fulfilments' do
          before { steps.process(delivery_address: mock_address) }

          subject { fulfilments }

          it { is_expected.to have_received(:can_fulfil_shipments?) }
        end
      end

      context 'and fulfilments missing' do
        let(:fulfilments) { nil }

        it { is_expected.to include(:warnings) }
      end

      context 'and cannot fulfil shipments' do
        let(:fulfilments) { double(can_fulfil_shipments?: false) }

        it { expect { subject }.to raise_error(DeliveryStep::CannotFulfilShipmentsError) }
      end
    end

    context 'when applying delivery promotions' do
      subject { steps.process(delivery_address: mock_address) }

      context 'and can apply delivery promotions' do
        before do
          expect(promotions).to receive(:apply_delivery_promotions) do |state|
            state.merge(promotions: [:free_delivery])
          end
        end

        it { is_expected.to include(:promotions) }
      end

      context 'and promotions missing' do
        let(:fulfilments) { nil }

        it { is_expected.to include(:warnings) }
      end
    end

    context 'when completing step' do
      before { steps.process(delivery_address: mock_address) }

      subject { complete_step }

      it { is_expected.to have_received(:delivery) }
    end
  end
end
