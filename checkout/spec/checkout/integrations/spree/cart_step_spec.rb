module MarketTown::Checkout
  describe CartStep do
    let(:deps) { Spree::Container.new }

    context 'when processing cart step' do
      context 'and the order has line items' do
        let(:order) { double(:order, line_items: [:item], update!: nil) }
        # let(:order) { create(:order_with_totals) }

        before(:each) do
          CartStep.new(deps).process(order: order)
        end

        context 'then the order' do
          subject { order }

          it { is_expected.to have_received(:update!).with(state: :address) }
          # its(:state) { is_expected.to eq(:address) }
        end
      end

      context 'and the order does not have line items' do
        let(:order) { double(:order, line_items: []) }
        # let(:order) { create(:order) }

        subject { CartStep.new(deps).process(order: order) }

        it { expect { subject }.to raise_error(CartStep::NoLineItemsError) }
      end
    end
  end
end
