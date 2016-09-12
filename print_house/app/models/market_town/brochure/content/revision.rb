module MarketTown
  module Brochure
    module Content
      class Revision < ActiveRecord::Base
        has_many :change_revisions
        has_many :changes, through: :change_revisions
      end
    end
  end
end
