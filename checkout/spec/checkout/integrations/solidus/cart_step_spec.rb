require 'rails_helper'
require 'checkout/integrations/spree_like/cart_step'

module MarketTown::Checkout
  describe CartStep do
    let(:deps) { Solidus::Container.new }
    it_behaves_like 'spree-like container during cart step'
  end
end
