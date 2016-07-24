module MarketTown::Checkout
  describe Contracts do
    let(:state) { {} }

    describe Contracts::UserAddressStorage do
      it_behaves_like 'UserAddressStorage'
    end

    describe Contracts::Credit do
      it_behaves_like 'Credit'
    end

    describe Contracts::Finish do
      it_behaves_like 'Finish'
    end

    describe Contracts::Fulfilments do
      it_behaves_like 'Fulfilments'
    end

    describe Contracts::Notifications do
      it_behaves_like 'Notifications'
    end

    describe Contracts::Order do
      it_behaves_like 'Order'
    end

    describe Contracts::Payments do
      it_behaves_like 'Payments'
    end

    describe Contracts::Promotions do
      it_behaves_like 'Promotions'
    end

    describe Contracts::Tax do
      it_behaves_like 'Tax'
    end
  end
end
