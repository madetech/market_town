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

      context 'and user wishes to save addresses' do
        let(:user) { create(:user) }

        let(:order) do
          create(:order_with_totals, user: user,
                                     bill_address: nil,
                                     ship_address: nil)
        end

        before(:each) do
          AddressStep.new(deps).process(order: order,
                                        billing_address: mock_address.merge(save: true),
                                        use_billing_address: true)
        end

        context 'then the users billing address' do
          subject { user.reload.bill_address.address1 }
          it { is_expected.to eq(order.billing_address.address1) }
        end

        context 'then the users delivery address' do
          subject { user.reload.ship_address.address1 }
          it { is_expected.to eq(order.shipping_address.address1) }
        end
      end

      context 'and address has region populated' do
        let(:order) { create(:order_with_totals) }
        let(:address_with_region) { mock_address.merge(region: 'Essex') }

        before(:each) do
          create(:state, name: 'Essex')
          AddressStep.new(deps).process(order: order,
                                        billing_address: address_with_region,
                                        delivery_address: address_with_region)
        end

        context 'then the order state' do
          subject { order.state }
          it { is_expected.to be_present }
        end
      end

      context 'and address has non-existant region populated' do
        let(:order) { create(:order_with_totals) }
        let(:address_with_region) { mock_address.merge(region: 'Meh') }

        subject do
          AddressStep.new(deps).process(order: order,
                                        billing_address: address_with_region,
                                        delivery_address: address_with_region)
        end

        it { expect { subject }.to raise_error(Spree::AddressTransformation::RegionNotFoundInSpreeError) }
      end

      context 'and address has non-existant country' do
        let(:order) { create(:order_with_totals) }
        let(:address_with_country) { mock_address.merge(country: 'DE') }

        subject do
          AddressStep.new(deps).process(order: order,
                                        billing_address: address_with_country,
                                        delivery_address: address_with_country)
        end

        it { expect { subject }.to raise_error(Spree::AddressTransformation::CountryNotFoundInSpreeError) }
      end
    end
  end
end
