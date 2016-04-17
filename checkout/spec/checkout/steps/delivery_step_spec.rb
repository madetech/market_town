module MarketTown::Checkout
  describe DeliveryStep do
    let(:fulfilment) { double(can_fulfil_shipments?: true) }
    let(:promotions) { double(apply_delivery_promotions: nil) }

    let(:deps) { Dependencies.new(fulfilment: fulfilment,
                                  promotions: promotions,
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

        context 'and can fulfil' do
          context 'then fulfilment' do
            before { steps.process(delivery_address: mock_address) }

            subject { fulfilment }

            it { is_expected.to have_received(:can_fulfil_shipments?) }
          end
        end

        context 'and fulfilment missing' do
          let(:fulfilment) { nil }

          it { is_expected.to include(:warnings) }
        end

        context 'and cannot fulfil shipments' do
          let(:fulfilment) { double(can_fulfil_shipments?: false) }

          it { expect { subject }.to raise_error(DeliveryStep::CannotFulfilShipmentsError) }
        end

        context 'and can apply delivery promotions' do
          before do
            expect(promotions).to receive(:apply_delivery_promotions) do |state|
              state.merge(promotions: [:free_delivery])
            end
          end

          it { is_expected.to include(:promotions) }
        end

        context 'and promotions missing' do
          let(:fulfilment) { nil }

          it { is_expected.to include(:warnings) }
        end

        context 'and cannot apply promotions' do
          before do
            expect(promotions).to receive(:apply_delivery_promotions) do |state|
              raise 'Something went wrong applying promotion'
            end
          end

          it { expect { subject }.to raise_error(DeliveryStep::CannotApplyPromotionsError) }
        end
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
  end
end
