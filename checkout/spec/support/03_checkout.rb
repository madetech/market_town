require 'market_town/checkout'
require 'market_town/checkout/integrations/solidus'
require 'market_town/checkout/integrations/spree'

Dir[File.expand_path('../../../lib/market_town/checkout/contracts/**/*.rb', __FILE__)].each do |contract_file|
  require contract_file
end
