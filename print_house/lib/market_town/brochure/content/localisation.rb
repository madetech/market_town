module MarketTown
  module Brochure
    module Content
      class Localisation
        attr_reader :config

        def initialize(config:)
          @config = config
        end

        def contents_in_locale(contents, locale)
          contents.map { |content| content_in_locale(content, locale) }
        end

        private

        def content_in_locale(content, locale)
          all_locales(locale).reduce({}) do |translated_content, locale|
            translated_content.merge(content.translations[locale])
          end
        end

        def all_locales(locale)
          [config.default_locale, *config.fallback_locales[locale].reverse, locale]
        end
      end
    end
  end
end
