module MarketTown::Checkout
  describe AddressStep do
    let(:fulfilment) { double(can_fulfil_address?: true) }
    let(:address_storage) { double(store: nil) }

    let(:deps) { Dependencies.new(fulfilment: fulfilment,
                                  address_storage: address_storage) }

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
          let(:fulfilment) { double(can_fulfil_address?: false) }

          it { expect { subject }.to raise_error(AddressStep::CannotFulfilAddressError) }
        end

        context 'and no fulfilment' do
          let(:fulfilment) { nil }

          it { is_expected.to include(:warnings) }
        end
      end

      context 'and saving valid addresses' do
        before { steps.process(billing_address: mock_address.merge(save: true),
                               delivery_address: mock_address.merge(save: true)) }

        context 'then the address storage' do
          subject { address_storage }
          it { is_expected.to have_received(:store).twice }
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
  end
end
