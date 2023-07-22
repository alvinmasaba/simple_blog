class DraftPick < ApplicationRecord
    belongs_to :team
    belongs_to :owned_by, class_name: 'Team'
    has_one :asset, as: :assetable
  
    validates :round, presence: true, inclusion: { in: ['first', 'second'] }
    validates :year, presence: true
    validates :protections, presence: true
  end
  