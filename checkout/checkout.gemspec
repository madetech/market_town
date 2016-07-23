require_relative 'lib/market_town/checkout/version'

Gem::Specification.new do |s|
  s.name     = 'market_town-checkout'
  s.version  = MarketTown::Checkout::VERSION
  s.licenses = ['MIT']
  s.summary  = 'Business logic for e-commerce checkouts'
  s.authors  = ['Luke Morton']
  s.email    = 'luke@madetech.com'
  s.files    = Dir['lib/**/*.rb'] + ['README.md']
  s.homepage = 'https://github.com/madetech/market_town'

  s.add_dependency 'activemodel'
  s.add_dependency 'countries'

  s.add_development_dependency 'codecov'
  s.add_development_dependency 'factory_girl'
  s.add_development_dependency 'pry-byebug', '~> 3.4.0'
  s.add_development_dependency 'rake', '~> 11.2.0'
  s.add_development_dependency 'rspec-rails', '~> 3.5.0'
  s.add_development_dependency 'rspec', '~> 3.5.0'
  s.add_development_dependency 'rubocop-rspec', '1.4.0'
  s.add_development_dependency 'rubocop', '~> 0.41.0'
  s.add_development_dependency 'simplecov', '~> 0.12.0'
end
