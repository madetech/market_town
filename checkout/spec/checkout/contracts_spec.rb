module MarketTown::Checkout::Contracts
  describe AddressStorage do
    it_behaves_like 'AddressStorage'
  end

  describe Credit do
    it_behaves_like 'Credit'
  end

  describe Finish do
    it_behaves_like 'Finish'
  end

  describe Fulfilments do
    it_behaves_like 'Fulfilments'
  end

  describe Notifications do
    it_behaves_like 'Notifications'
  end

  describe Order do
    it_behaves_like 'Order'
  end

  describe Payments do
    it_behaves_like 'Payments'
  end

  describe Promotions do
    it_behaves_like 'Promotions'
  end

  describe Tax do
    it_behaves_like 'Tax'
  end
end
