require_relative './spec_helper'

module MarketTown::Checkout
  describe Contracts do
    let(:state) { { order: create(:order) } }

    describe Spree::UserAddressStorage do
      before(:each) do
        create(:country, iso: 'US', iso3: 'USA')
        state[:billing_address] = mock_address
        state[:delivery_address] = mock_address
      end

      it_behaves_like 'UserAddressStorage'
    end
  end
end
