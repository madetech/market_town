module MarketTown
  module Brochure
    class Change < ActiveRecord::Base
      belongs_to :release
      belongs_to :resource

      has_many :change_revisions
      has_many :revisions, through: :change_revisions,
                           as: :contents
    end
  end
end
