module MarketTown::Checkout
  describe AddressStep do
    let(:steps) { AddressStep.new }
    let(:mock_address) do
      { name: 'Luke Morton',
        address_1: '21 Cool St',
        locality: 'London',
        postal_code: 'N1 1PQ',
        country: 'GB' }
    end

    context 'when processing checkout' do
      context 'with valid billing address' do
        subject { steps.process(billing_address: mock_address,
                                delivery_address: mock_address) }

        it { is_expected.to include(:billing_address, :delivery_address) }
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
