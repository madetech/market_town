module MarketTown
  module Brochure
    class Site < ActiveRecord::Base
      has_many :content_revisions
      has_many :resources
    end
  end
end
