module MarketTown
  module Brochure
    module Content
      class RevisionRecommendations
        def recommendations(site:)
          { new_content: new_content(site),
            new_revisions: new_revisions(site) }
        end

        private

        def new_content(site)
          site.content_revisions.includes(:resource)
                                .where(ref: site.content_revisions.pluck(:ref))
                                .where(resource: nil)
        end

        def new_revisions(site)
          content_refs = site.content_revisions.includes(:resource)
                                               .where(resource: nil)
                                               .pluck(:ref)
          site.content_revisions.includes(:resource)
                                .where(ref: content_refs)
                                .where.not(resource: nil)
        end
      end
    end
  end
end
