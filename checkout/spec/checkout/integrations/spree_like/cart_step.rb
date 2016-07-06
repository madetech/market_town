module MarketTown::Checkout
  shared_examples_for 'spree-like container during cart step' do
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

      context 'and the order does not have line items' do
        let(:order) { create(:order) }

        subject { CartStep.new(deps).process(order: order) }

        it { expect { subject }.to raise_error(CartStep::NoLineItemsError) }
      end
    end
  end
end
