module MarketTown
  module Checkout
    # When you request a dependency that is not defined in {Dependencies} then
    # a {MissingDependency} exception will be raised. This is used to provide
    # useful warnings in development in {Step}'s.
    #
    # ``` ruby
    # container = MarketTown::Checkout::Dependencies.new
    #
    # begin
    #   container.fulfilments.propose_shipments(state)
    # rescue MissingDependency
    #   puts 'Did not propose shipments'
    # end
    # ```
    #
    # See {AddressStep#ensure_delivery} and {DeliveryStep#validate_shipments}
    # for real world examples.
    #
    class MissingDependency < RuntimeError; end
  end
end
