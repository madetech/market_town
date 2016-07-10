require 'rubygems'
gemfile = File.expand_path("/Users/luke/Work/market_town/checkout/Gemfile.solidus.rb", __FILE__)

ENV['BUNDLE_GEMFILE'] = gemfile
require 'bundler'
Bundler.setup
