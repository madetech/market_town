require_relative './spec_helper'
require_relative '../spree_like/cart_step'

module MarketTown::Checkout
  describe CartStep do
    let(:deps) { Solidus::Container.new }
    it_behaves_like 'spree-like container during cart step'
  end
end
