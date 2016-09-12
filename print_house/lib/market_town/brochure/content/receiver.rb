#
# ``` ruby
# module MarketTown::Brochure
#   receiver = Content::Receiver.new(adapters: [DefaultAdapter.new(config: config)])
#
#   content = { ref: 'my-post',
#               title: 'My blog post',
#               body: '<p>Some content</p>' }
#
#   site = Site.first
#
#   receiver.receive(content).tap do |content_attrs|
#     content = site.content_revisions.create!(content_attrs)
#     Rails.logger.info("Content::Revision<#{content.id}> created from #{content_attrs}")
#   end
# end
# ```
#
# ``` ruby
# module MarketTown::Brochure
#   receiver = Content::Receiver.new(adapters: [Content::ContentfulAdapter.new,
#                                               DefaultAdapter.new(config: config)])
#
#   content = { sys: { id: 'contentful-id' },
#               fields: { title: { 'en-GB': 'Translated title' },
#                         body: { 'en-GB': '<p>Some body</p>' } } }
#
#   site = Site.first
#
#   receiver.receive(content).tap do |content_attrs|
#     content = site.content_revisions.create!(content_attrs)
#     Rails.logger.info("Content::Revision<#{content.id}> created from #{content_attrs}")
#   end
# end
# ```
#
module MarketTown
  module Brochure
    module Content
      class Receiver
        attr_reader :adapters

        def initialize(adapters:)
          @adapters = adapters
        end

        def receive(content)
          adapter = adapter_for_content(content)

          { ref: adapter.reference_for(content),
            translations: adapter.translations_for(content) }
        end

        private

        def adapter_for_content(content)
          adapters.detect { |adapter| adapter.can_adapt?(content) }
        end
      end
    end
  end
end
