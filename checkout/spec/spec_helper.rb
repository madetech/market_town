if ENV['CI'] == 'true'
  require 'simplecov'
  SimpleCov.root = File.expand_path(Dir.pwd + '/../')
  SimpleCov.start
  require 'codecov'
  SimpleCov.formatter = SimpleCov::Formatter::Codecov
end

require 'pry-byebug'
require 'market_town/checkout'
