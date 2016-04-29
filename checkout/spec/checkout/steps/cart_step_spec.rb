module MarketTown::Checkout
  describe CartStep do
    let(:order) { double(has_line_items?: true) }
    let(:address_storage) { double(load_default: nil) }
    let(:finish) { double(cart_step: nil) }

    let(:deps) { Dependencies.new(order: order,
                                  address_storage: address_storage,
                                  finish: finish) }

    let(:step) { CartStep.new(deps) }

    context 'when processing cart step' do
      subject { step.process({}) }

      context 'and the order has line items' do
        it { is_expected.to be_truthy }
      end

      context 'and the order does not have line items' do
        let(:order) { double(has_line_items?: false) }
        it { expect { subject }.to raise_error(CartStep::NoLineItemsError) }
      end
    end

    context 'when loading default addresses' do
      context 'and has default address' do
        let(:mock_address) do
          { name: 'Luke Morton',
            address_1: '21 Cool St',
            locality: 'London',
            postal_code: 'N1 1PQ',
            country: 'GB' }
        end

        let(:address_storage) { double(load_default: { delivery_address: mock_address }) }
        subject { step.process({}) }
        it { is_expected.to include(delivery_address: mock_address) }
      end

      context 'and does not have default address' do
        let(:address_storage) { double(load_default: nil) }
        subject { step.process({}) }
        it { is_expected.to be_truthy }
      end

      context 'and address storage missing' do
        let(:address_storage) { nil }
        subject { step.process({}) }
        it { is_expected.to include(:warnings) }
      end
    end
  end
end
