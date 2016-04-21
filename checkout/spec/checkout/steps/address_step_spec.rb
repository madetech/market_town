module MarketTown::Checkout
  describe AddressStep do
    let(:fulfilments) { double(can_fulfil_address?: true, propose_shipments: nil) }
    let(:address_storage) { double(store: nil) }

    let(:deps) { Dependencies.new(fulfilments: fulfilments,
                                  address_storage: address_storage,
                                  logger: double(warn: nil)) }

    let(:steps) { AddressStep.new(deps) }

    let(:mock_address) do
      { name: 'Luke Morton',
        address_1: '21 Cool St',
        locality: 'London',
        postal_code: 'N1 1PQ',
        country: 'GB' }
    end

    context 'when processing checkout' do
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

    context 'and saving valid addresses' do
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

      context 'and cannot propose shipments' do
        before do
          expect(fulfilments).to receive(:propose_shipments) do |state|
            raise 'Something went wrong proposing shipments'
          end
        end

        it { expect { subject }.to raise_error(AddressStep::CannotProposeShipmentsError) }
      end

      context 'and no fulfilments' do
        let(:fulfilments) { nil }

        it { is_expected.to include(:warnings) }
      end
    end
  end
end
