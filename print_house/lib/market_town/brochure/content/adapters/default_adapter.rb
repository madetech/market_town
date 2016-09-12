module MarketTown
  module Brochure
    module Content
      class DefaultAdapter
        attr_reader :config

        def initialize(config:)
          @config = config
        end

        def can_adapt?(content)
          true
        end

        def reference_for(content)
          content[:guid] || content[:id] || Digest::SHA256.hexdigest(content.to_s)
        end

        def translations_for(content)
          { (content[:locale] || config.default_locale) => content }
        end
      end
    end
  end
end
