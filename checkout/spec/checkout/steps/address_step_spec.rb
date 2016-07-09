module MarketTown::Checkout
  describe AddressStep do
    let(:fulfilments) { double(can_fulfil_address?: true, propose_shipments: nil) }

    let(:user_address_storage) { double(store_billing_address: nil,
                                   store_delivery_address: nil) }

    let(:finish) { double(address_step: nil) }

    let(:deps) { Dependencies.new(fulfilments: fulfilments,
                                  user_address_storage: user_address_storage,
                                  finish: finish,
                                  logger: double(warn: nil)) }

    let(:step) { AddressStep.new(deps) }

    context 'when processing address step' do
      context 'with valid addresses' do
        subject { step.process(billing_address: mock_address,
                               delivery_address: mock_address) }

        it { is_expected.to include(:billing_address, :delivery_address) }

        context 'and cannot fulfil delivery address' do
          let(:fulfilments) { double(can_fulfil_address?: false) }

          it { expect { subject }.to raise_error(AddressStep::CannotFulfilAddressError) }
        end
      end

      context 'with empty billing address' do
        subject { step.process(billing_address: nil,
                               delivery_address: mock_address) }

        it { expect { subject }.to raise_error(AddressStep::InvalidAddressError) }
      end

      context 'with empty delivery address' do
        subject { step.process(billing_address: mock_address,
                               delivery_address: nil) }

        it { expect { subject }.to raise_error(AddressStep::InvalidAddressError) }
      end

      context 'with invalid country in billing address' do
        subject { step.process(billing_address: mock_address.merge(country: 'invalid'),
                               delivery_address: mock_address) }

        it { expect { subject }.to raise_error(AddressStep::InvalidAddressError) }
      end
    end

    context 'when using billing address as delivery address' do
      subject { step.process(billing_address: mock_address, use_billing_address: true) }
       it { is_expected.to include(:billing_address, :delivery_address) }
    end

    context 'when saving valid addresses' do
      subject { step.process(billing_address: mock_address.merge(save: true),
                             delivery_address: mock_address.merge(save: true)) }

      it { is_expected.to include(:billing_address, :delivery_address) }

      context 'then the address storage' do
        before { step.process(billing_address: mock_address.merge(save: true),
                              delivery_address: mock_address.merge(save: true)) }

        subject { user_address_storage }

        it { is_expected.to have_received(:store_billing_address) }
        it { is_expected.to have_received(:store_delivery_address) }
      end
    end

    context 'when proposing shipments' do
      subject { step.process(billing_address: mock_address,
                             delivery_address: mock_address) }

      it { is_expected.to include(:billing_address, :delivery_address) }

      context 'then fulfilments' do
        before { step.process(billing_address: mock_address,
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
      before { step.process(billing_address: mock_address,
                            delivery_address: mock_address) }

      subject { finish }

      it { is_expected.to have_received(:address_step) }
    end
  end
end
