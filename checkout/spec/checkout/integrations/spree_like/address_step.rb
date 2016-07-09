module MarketTown::Checkout
  shared_examples_for 'address step using spree-like container' do
    context 'when processing address step' do
      before(:each) { create(:country, iso: 'GB') }

      context 'and addresses valid' do
        let(:order) { create(:order_with_totals) }

        before(:each) do
          AddressStep.new(deps).process(order: order,
                                        billing_address: mock_address,
                                        delivery_address: mock_address)
        end

        context 'then the order' do
          subject { order }
          it { is_expected.to be_delivery }
        end

        context 'then the orders billing address' do
          subject { order.billing_address.address1 }
          it { is_expected.to eq(mock_address[:address_1]) }
        end

        context 'then the orders shipping address' do
          subject { order.shipping_address.address1 }
          it { is_expected.to include(mock_address[:address_1]) }
        end
      end
    end
  end
end
