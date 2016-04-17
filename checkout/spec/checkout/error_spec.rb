module MarketTown::Checkout
  describe Error do
    context 'when retrieving symbol representation of error' do
      subject do
        class MockError < Error
        end

        MockError.new.error
      end

      it { is_expected.to eq(:mock_error) }
    end
  end
end
