module MarketTown
  module Brochure
    module Content
      class ContentfulAdapter
        attr_reader :config

        def initialize(config:)
          @config = config
        end

        def can_adapt?(content)
          content.key?(:sys) and content[:sys].key?(:id)
        end

        def reference_for(content)
          content[:sys][:id]
        end

        def translations_for(content)
          content[:fields].each_with_object({}) do |(field, values), translations|
            values.each do |locale, value|
              translations[locale] ||= {}
              translations[locale][field] = value
            end
          end
        end
      end
    end
  end
end
