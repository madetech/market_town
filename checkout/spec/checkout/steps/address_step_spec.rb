module MarketTown::Checkout
  describe AddressStep do
    let(:fulfilments) { double(can_fulfil_address?: true, propose_shipments: nil) }
    let(:address_storage) { double(store: nil) }
    let(:complete_step) { double(address: nil) }

    let(:deps) { Dependencies.new(fulfilments: fulfilments,
                                  address_storage: address_storage,
                                  complete_step: complete_step,
                                  logger: double(warn: nil)) }

    let(:steps) { AddressStep.new(deps) }

    let(:mock_address) do
      { name: 'Luke Morton',
        address_1: '21 Cool St',
        locality: 'London',
        postal_code: 'N1 1PQ',
        country: 'GB' }
    end

    context 'when processing address step' do
      context 'with valid addresses' do
        subject { steps.process(billing_address: mock_address,
                                delivery_address: mock_address) }

        it { is_expected.to include(:billing_address, :delivery_address) }

        context 'and cannot fulfil delivery address' do
          let(:fulfilments) { double(can_fulfil_address?: false) }

          it { expect { subject }.to raise_error(AddressStep::CannotFulfilAddressError) }
        end
      end

      context 'with empty billing address' do
        subject { steps.process(billing_address: nil,
                                delivery_address: mock_address) }

        it { expect { subject }.to raise_error(AddressStep::InvalidAddressError) }
      end

      context 'with empty billing address' do
        subject { steps.process(billing_address: nil,
                                delivery_address: mock_address) }

        it { expect { subject }.to raise_error(AddressStep::InvalidAddressError) }
      end

      context 'with empty delivery address' do
        subject { steps.process(billing_address: mock_address,
                                delivery_address: nil) }

        it { expect { subject }.to raise_error(AddressStep::InvalidAddressError) }
      end

      context 'with invalid country in billing address' do
        subject { steps.process(billing_address: mock_address.merge(country: 'invalid'),
                                delivery_address: mock_address) }

        it { expect { subject }.to raise_error(AddressStep::InvalidAddressError) }
      end
    end

    context 'when using billing address as delivery address' do
      subject { steps.process(billing_address: mock_address, use_billing_address: true) }

      it { is_expected.to include(:billing_address, :delivery_address) }
    end

    context 'when saving valid addresses' do
      subject { steps.process(billing_address: mock_address.merge(save: true),
                              delivery_address: mock_address.merge(save: true)) }

      it { is_expected.to include(:billing_address, :delivery_address) }

      context 'then the address storage' do
        before { steps.process(billing_address: mock_address.merge(save: true),
                               delivery_address: mock_address.merge(save: true)) }

        subject { address_storage }

        it { is_expected.to have_received(:store) }
      end
    end

    context 'when proposing shipments' do
      subject { steps.process(billing_address: mock_address,
                              delivery_address: mock_address) }

      it { is_expected.to include(:billing_address, :delivery_address) }

      context 'then fulfilments' do
        before { steps.process(billing_address: mock_address,
                               delivery_address: mock_address) }

        subject { fulfilments }

        it { is_expected.to have_received(:propose_shipments) }
      end

      context 'and no fulfilments' do
        let(:fulfilments) { nil }

        it { is_expected.to include(:warnings) }
      end
    end

    context 'when completing step' do
      before { steps.process(billing_address: mock_address,
                             delivery_address: mock_address) }

      subject { complete_step }

      it { is_expected.to have_received(:address) }
    end
  end
end
