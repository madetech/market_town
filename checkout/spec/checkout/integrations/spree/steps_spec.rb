require_relative './spec_helper'
require_relative '../spree_like/cart_step'
require_relative '../spree_like/address_step'

module MarketTown::Checkout
  describe 'Steps with Spree integration' do
    let(:deps) { Spree::Container.new }

    describe CartStep do
      it_behaves_like 'cart step using spree-like container'
    end

    describe AddressStep do
      it_behaves_like 'address step using spree-like container'
    end
  end
end
