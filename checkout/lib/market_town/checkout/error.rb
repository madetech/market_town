module MarketTown
  module Checkout
    class Error < RuntimeError
      def error
        self.class.name.sub('MarketTown::Checkout::', '')
                       .split('::')
                       .join('_')
                       .gsub(/([A-Z]+)([A-Z][a-z])/, '\1_\2')
                       .gsub(/([a-z])([A-Z])/, '\1_\2')
                       .downcase
                       .to_sym
      end
    end
  end
end
