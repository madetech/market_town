module MarketTown::Checkout
  shared_examples_for 'cart step using spree-like container' do
    context 'when processing cart step' do
      context 'and the order has line items' do
        let(:order) { create(:order_with_totals) }

        before(:each) do
          CartStep.new(deps).process(order: order)
        end

        context 'then the order' do
          subject { order }
          it { is_expected.to be_address }
        end
      end

      context 'and the customer has a saved address' do
        let(:customer_address) { create(:address) }

        let(:user) { create(:user, bill_address: customer_address,
                                   ship_address: customer_address) }

        before(:each) do
          CartStep.new(deps).process(order: order)
        end

        context 'to an order that already has addresses associated' do
          let(:order) { create(:order_with_totals, user: user) }
          subject { order.billing_address }
          it { is_expected.to eq(customer_address) }
        end

        context 'to an order that does not have addresses associated' do
          let(:order) { create(:order_with_totals, user: user,
                        bill_address: nil,
                        ship_address: nil) }
          subject { order.billing_address }
          it { is_expected.to eq(customer_address) }
        end
      end

      context 'and the order does not have line items' do
        let(:order) { create(:order) }

        subject { CartStep.new(deps).process(order: order) }

        it { expect { subject }.to raise_error(CartStep::NoLineItemsError) }
      end
    end
  end
end
