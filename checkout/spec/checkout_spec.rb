module MarketTown
  describe Checkout do
    context 'when processing checkout step' do
      let(:deps) { Checkout::Dependencies.new }
      let(:step_name) { :address }
      let(:state) { {} }

      it 'should delegate to AddressStep' do
        expect(Checkout::AddressStep).to receive(:process).with(state)
        Checkout.process_step(step: step_name,
                              dependencies: deps,
                              state: state)
      end
    end
  end
end
