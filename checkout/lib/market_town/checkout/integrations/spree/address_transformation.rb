module MarketTown
  module Checkout
    module Spree
      class AddressTransformation
        class RegionNotFoundInSpreeError < Error; end
        class CountryNotFoundInSpreeError < Error; end

        def transform(address)
          { first_name: 'See #last_name',
            last_name: address[:name],
            company: address[:company],
            address1: address[:address_1],
            address2: address[:address_2],
            city: address[:locality],
            state: find_state(address[:region]),
            state_name: address[:region],
            zipcode: address[:postal_code],
            country: find_country(address[:country]),
            phone: address[:phone_number] || '0' }
        end

        private

        def find_state(region)
          if region
            ::Spree::State.find_by!(name: region)
          end
        rescue ActiveRecord::RecordNotFound
          raise RegionNotFoundInSpreeError.new(region)
        end

        def find_country(country)
          ::Spree::Country.find_by!(iso: country)
        rescue ActiveRecord::RecordNotFound
          raise CountryNotFoundInSpreeError.new(country)
        end
      end
    end
  end
end
