module MarketTown::Checkout
  describe CartStep do
    let(:order) { double(has_line_items?: true) }
    let(:user_address_storage) { double(load_default_addresses: nil) }
    let(:finish) { double(cart_step: nil) }

    let(:deps) { Dependencies.new(order: order,
                                  user_address_storage: user_address_storage,
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
        let(:user_address_storage) { double(load_default_addresses: { delivery_address: mock_address }) }
        subject { step.process({}) }
        it { is_expected.to include(delivery_address: mock_address) }
      end

      context 'and does not have default address' do
        let(:user_address_storage) { double(load_default_addresses: nil) }
        subject { step.process({}) }
        it { is_expected.to be_truthy }
      end

      context 'and address storage missing' do
        let(:user_address_storage) { nil }
        subject { step.process({}) }
        it { is_expected.to include(:warnings) }
      end
    end
  end
end
