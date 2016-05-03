module MarketTown
  module Checkout
    module Contracts
      class Notifications
        def notify(notification, state)
        end

        shared_examples_for 'Notifications' do
          context '#notify' do
            subject { described_class.new.notify(:notification_name, {}) }
            it_behaves_like 'a command method'
          end
        end
      end
    end
  end
end
