require 'active_model'
require 'countries/iso3166'

module Checkout
  class Address
    class InvalidError < RuntimeError; end

    include ActiveModel::Model

    def self.validate!(type, address_attrs)
      address = new(address_attrs)

      if address.invalid?
        raise InvalidError.new(address_type: type,
                               address: address_attrs,
                               errors: address.errors.messages)
      end
    end

    attr_accessor :name,
                  :company,
                  :address_1,
                  :address_2,
                  :address_3,
                  :locality,
                  :region,
                  :postal_code,
                  :country

    validates :name, presence: true
    validates :address_1, presence: true
    validates :locality, presence: true
    validates :postal_code, presence: true
    validates :country, presence: true

    validate :country_is_iso3166

    def country_is_iso3166
      if ISO3166::Country.find_country_by_alpha2(country).nil?
        errors.add(:country, 'Country was not valid ISO3166 alpha 2')
      end
    end
  end
end