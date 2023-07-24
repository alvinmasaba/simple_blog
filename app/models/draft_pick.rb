class DraftPick < ApplicationRecord
    after_create :create_corresponding_asset
    after_update :update_asset_team
    
    belongs_to :team
    belongs_to :owned_by, class_name: 'Team'
    has_one :asset, as: :assetable
  
    validates :round, presence: true, inclusion: { in: [1, 2] }
    validates :year, presence: true

    private

    def create_corresponding_asset
      Asset.create(assetable: self, team: self.team)
    end

    def update_asset_team
      self.asset.update(team: self.team)
    end
  end
  