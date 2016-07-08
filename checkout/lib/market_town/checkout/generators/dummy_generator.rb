require 'generators/spree/dummy/dummy_generator'

module MarketTown
  module Checkout
    class DummyGenerator < Spree::DummyGenerator
      def gemfile_path
        ENV['BUNDLE_GEMFILE'] or raise 'Please specify BUNDLE_GEMFILE'
      end
    end
  end
end
