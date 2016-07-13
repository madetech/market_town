require 'market_town/checkout/rack'
require 'rack'

module MarketTown::Checkout
  describe Rack::NotFound do
    context 'when step recognised' do
      let(:request) { ::Rack::MockRequest.env_for('/checkout/cart') }
      let(:response) { Rack.app.call(request) }

      context 'then the status' do
        subject { response.status }
        it { is_expected.to eq(200) }
      end
    end
  end
end
