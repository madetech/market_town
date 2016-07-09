require 'active_model'
require 'countries/iso3166'

module MarketTown
  module Checkout
    # An Address model for validating addresses. This class is for internal
    # use only. You should validate addresses yourself before passing them
    # into {MarketTown::Checkout}.
    #
    # @api private
    #
    class Address
      # Validates an address, throws {InvalidError} if invalid
      #
      # @param [Hash] address_attrs
      # @option address_attrs [String] :name
      # @option address_attrs [String] :company
      # @option address_attrs [String] :address_1
      # @option address_attrs [String] :address_2
      # @option address_attrs [String] :locality
      # @option address_attrs [String] :region
      # @option address_attrs [String] :postal_code
      # @option address_attrs [String] :country must be valid ISO3166 alpha 2
      # @option address_attrs [String] :phone_number
      #
      # @raise [InvalidError] if address invalid
      #
      def self.validate!(address_attrs)
        address = new(address_attrs)

        if address.invalid?
          raise InvalidError.new(address: address_attrs,
                                 errors: address.errors.messages)
        end
      end

      include ActiveModel::Model

      attr_accessor :name,
                    :company,
                    :address_1,
                    :address_2,
                    :locality,
                    :region,
                    :postal_code,
                    :country,
                    :phone_number,
                    :save

      validates :name, presence: true
      validates :address_1, presence: true
      validates :locality, presence: true
      validates :postal_code, presence: true
      validates :country, presence: true

      validate :country_is_iso3166

      private

      def country_is_iso3166
        if ISO3166::Country.find_country_by_alpha2(country).nil?
          errors.add(:country, 'Country was not valid ISO3166 alpha 2')
        end
      end

      # Thrown when {Address} invalid
      #
      class InvalidError < RuntimeError
        attr_reader :data

        def initialize(data)
          @data = data
        end
      end
    end
  end
end
