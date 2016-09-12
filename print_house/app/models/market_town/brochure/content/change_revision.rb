module MarketTown
  module Brochure
    module Content
      class ChangeRevision < ActiveRecord::Base
        belongs_to :change
        belongs_to :revision
      end
    end
  end
end
