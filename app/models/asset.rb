class Asset < ApplicationRecord
    belongs_to :assetable, polymorphic: true
    belongs_to :team
end
  