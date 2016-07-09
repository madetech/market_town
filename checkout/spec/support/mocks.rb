module Mocks
  def mock_address
    { name: 'Luke Morton',
      address_1: '21 Cool St',
      locality: 'London',
      postal_code: 'N1 1PQ',
      country: 'GB' }
  end
end

RSpec.configure do |config|
  config.include Mocks
end
