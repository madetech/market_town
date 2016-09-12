module MarketTown
  module Brochure
    class Resource < ActiveRecord::Base
      belongs_to :site

      has_many :changes
    end
  end
end
