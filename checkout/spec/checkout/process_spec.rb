module MarketTown::Checkout
  describe Process do
    let(:logger) { double(error: nil) }
    let(:deps) { Dependencies.new(logger: logger) }
    let(:step) { double(process: {}) }
    let(:state) { {} }

    context 'when processing checkout step' do
      context 'then the step' do
        before { Process.new(deps).process(step, state) }
        subject { step }
        it { is_expected.to have_received(:process).with(state) }
      end

      context 'and the step raises an error' do
        before do
          expect(step).to receive(:process) do |state|
            raise Error.new('Could not process step')
          end

          begin
            Process.new(deps).process(step, state)
          rescue Error
          end
        end

        context 'then the logger' do
          subject { logger }
          it { is_expected.to have_received(:error) }
        end
      end
    end
  end
end
