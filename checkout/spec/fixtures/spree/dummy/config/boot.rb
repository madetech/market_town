require 'rubygems'
gemfile = File.expand_path("/Users/luke/Work/market_town/checkout/Gemfile.spree.rb", __FILE__)

ENV['BUNDLE_GEMFILE'] = gemfile
require 'bundler'
Bundler.setup
