ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../../../fixtures/solidus/dummy/config/environment.rb', __FILE__)
require 'rspec/rails'
ActiveRecord::Migration.maintain_test_schema!
require 'spree/testing_support/factories'
require 'spree/testing_support/order_walkthrough'

# We copied the OrderWalkthrough#up_to here for Solidus as it behaves
# differently to the Spree version of OrderWalkthrough.
#
# #up_to(:address) for in Solidus actually goes up to :delivery whereas
# Spree it goes up to the :address step.
#
# We also customised @country assignment to look for existing country
# rather than creating a new one so we don't have duplicate countries
# during tests.
#
def order_upto_address
  # Need to create a valid zone too...
  @zone = FactoryGirl.create(:zone)
  @country = Spree::Country.find_or_create_by(FactoryGirl.attributes_for(:country))
  @state = FactoryGirl.create(:state, country: @country)

  @zone.members << Spree::ZoneMember.create(zoneable: @country)

  # A shipping method must exist for rates to be displayed on checkout page
  FactoryGirl.create(:shipping_method, zones: [@zone]).tap do |sm|
    sm.calculator.preferred_amount = 10
    sm.calculator.preferred_currency = Spree::Config[:currency]
    sm.calculator.save
  end

  order = Spree::Order.create!(
    email: "spree@example.com",
    store: Spree::Store.first || FactoryGirl.create(:store)
  )

  FactoryGirl.create(:line_item, order: order)
  order.reload
  order.next!

  order
end
