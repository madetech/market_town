require 'market_town/checkout/rack'
require 'rack'

module MarketTown::Checkout
  describe Rack::NotFound do
    context 'when step not recognised' do
      let(:request) { ::Rack::MockRequest.env_for('/checkout/nope') }
      let(:response) { Rack.app.call(request) }

      context 'then the status' do
        subject { response.status }
        it { is_expected.to eq(404) }
      end
    end

    context 'when path not recognised' do
      let(:request) { ::Rack::MockRequest.env_for('/blah') }
      let(:response) { Rack.app.call(request) }

      context 'then the status' do
        subject { response.status }
        it { is_expected.to eq(404) }
      end
    end
  end
end
