#
# ``` ruby
# module MarketTown::Brochure
#   indexer = Release::Indexer.new(config: config, storage: storage)
#
#   indexer.index(Release.find_by(guid: guid)).each do |change, resource_release|
#     change.mark_as_applied
#     Rails.logger.info("Change<#{change.id}> applied to #{resource_release}")
#   end
# end
# ```
#
module MarketTown
  module Brochure
    module Release
      class Indexer
        attr_reader :config, :storage

        def initialize(config:, storage:)
          @config = config
          @storage = storage
        end

        def index(release)
          storage.delete_by(guid: release.guid)

          release_resources(release).each do |(change, resource_release)|
            storage.write(resource_release)
          end
        end

        private

        def release_resources(release)
          l10n = Content::Localisation.new(config: config)

          release.changes.flat_map do |change|
            config.locales.map do |locale|
              [change, { id: resource_id(change.resource, locale)
                         timestamp: release.timestamp,
                         release_guid: release.guid,
                         contents: l10n.contents_in_locale(change.contents, locale) }]
            end
          end
        end

        def resource_id(resource, locale)
          "#{resource.site.domain}/#{locale}/#{resource.path}"
        end
      end
    end
  end
end
