module MarketTown
  module Checkout
    # Spree integration for MarketTown::Checkout
    #
    module Spree
    end
  end
end

require 'market_town/checkout/integrations/spree/address_transformation'
require 'market_town/checkout/integrations/spree/finish'
require 'market_town/checkout/integrations/spree/fulfilments'
require 'market_town/checkout/integrations/spree/order'
require 'market_town/checkout/integrations/spree/user_address_storage'

require 'market_town/checkout/integrations/spree/container'
