ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../../../fixtures/spree/dummy/config/environment.rb', __FILE__)
require 'rspec/rails'
ActiveRecord::Migration.maintain_test_schema!
require 'spree/testing_support/factories'
require 'spree/testing_support/order_walkthrough'

def order_upto_address
  OrderWalkthrough.up_to(:address)
end
