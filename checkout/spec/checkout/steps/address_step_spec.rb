module MarketTown::Checkout
  describe AddressStep do
    let(:fulfilments) do
      double(propose_shipments: nil,
             can_fulfil_shipments?: true,
             apply_shipment_costs: nil)
    end

    let(:user_address_storage) do
      double(store_billing_address: nil,
             store_delivery_address: nil)
    end

    let(:finish) { double(address_step: nil) }

    let(:deps) do
      Dependencies.new(fulfilments: fulfilments,
                       user_address_storage: user_address_storage,
                       finish: finish,
                       logger: double(warn: nil))
    end

    let(:step) { AddressStep.new(deps) }

    context 'when processing address step' do
      context 'with valid addresses' do
        subject do
          step.process(billing_address: mock_address,
                       delivery_address: mock_address)
        end

        it { is_expected.to include(:billing_address, :delivery_address) }
      end

      context 'with empty billing address' do
        subject do
          step.process(billing_address: nil,
                       delivery_address: mock_address)
        end

        it { expect { subject }.to raise_error(AddressStep::InvalidAddressError) }
      end

      context 'with empty delivery address' do
        subject do
          step.process(billing_address: mock_address,
                       delivery_address: nil)
        end

        it { expect { subject }.to raise_error(AddressStep::InvalidAddressError) }
      end

      context 'with invalid country in billing address' do
        subject do
          step.process(billing_address: mock_address.merge(country: 'invalid'),
                       delivery_address: mock_address)
        end

        it { expect { subject }.to raise_error(AddressStep::InvalidAddressError) }
      end
    end

    context 'when using billing address as delivery address' do
      subject { step.process(billing_address: mock_address, use_billing_address: true) }
      it { is_expected.to include(:billing_address, :delivery_address) }
    end

    context 'when saving valid addresses' do
      subject do
        step.process(billing_address: mock_address.merge(save: true),
                     delivery_address: mock_address.merge(save: true))
      end

      it { is_expected.to include(:billing_address, :delivery_address) }

      context 'then the address storage' do
        before do
          step.process(billing_address: mock_address.merge(save: true),
                       delivery_address: mock_address.merge(save: true))
        end

        subject { user_address_storage }

        it { is_expected.to have_received(:store_billing_address) }
        it { is_expected.to have_received(:store_delivery_address) }
      end

      context 'and no user address storage' do
        let(:user_address_storage) { nil }

        it { is_expected.to include(:warnings) }
      end
    end

    context 'when proposing shipments' do
      subject do
        step.process(billing_address: mock_address,
                     delivery_address: mock_address)
      end

      it { is_expected.to include(:billing_address, :delivery_address) }

      context 'then fulfilments' do
        before do
          step.process(billing_address: mock_address,
                       delivery_address: mock_address)
        end

        subject { fulfilments }

        it { is_expected.to have_received(:propose_shipments) }
      end

      context 'and no fulfilments' do
        let(:fulfilments) { nil }

        it { is_expected.to include(:warnings) }
      end
    end

    context 'when validating shipments' do
      subject do
        step.process(billing_address: mock_address,
                     delivery_address: mock_address)
      end

      context 'and can fulfil' do
        context 'then fulfilments' do
          before do
            step.process(billing_address: mock_address,
                         delivery_address: mock_address)
          end

          subject { fulfilments }

          it { is_expected.to have_received(:can_fulfil_shipments?) }
        end
      end

      context 'and fulfilments missing' do
        let(:fulfilments) { nil }

        it { is_expected.to include(:warnings) }
      end

      context 'and cannot fulfil shipments' do
        let(:fulfilments) { double(propose_shipments: nil, can_fulfil_shipments?: false) }

        it { expect { subject }.to raise_error(AddressStep::CannotFulfilShipmentsError) }
      end
    end

    context 'when applying shipment costs' do
      subject do
        step.process(billing_address: mock_address,
                     delivery_address: mock_address)
      end

      context 'and can apply them' do
        context 'then fulfilments' do
          before do
            step.process(billing_address: mock_address,
                         delivery_address: mock_address)
          end

          subject { fulfilments }

          it { is_expected.to have_received(:apply_shipment_costs) }
        end
      end

      context 'and fulfilments missing' do
        let(:fulfilments) { nil }

        it { is_expected.to include(:warnings) }
      end
    end

    context 'when completing step' do
      before do
        step.process(billing_address: mock_address,
                     delivery_address: mock_address)
      end

      subject { finish }

      it { is_expected.to have_received(:address_step) }
    end
  end
end
