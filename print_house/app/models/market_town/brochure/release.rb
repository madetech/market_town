module MarketTown
  module Brochure
    class Release < ActiveRecord::Base
      belongs_to :site

      has_many :changes
      has_many :resources, through: :changes
    end
  end
end
