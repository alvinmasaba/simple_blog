class DraftPick < ApplicationRecord
    belongs_to :team
    belongs_to :owned_by, class_name: 'Team'
  
    validates :round, presence: true, inclusion: { in: ['first', 'second'] }
    validates :year, presence: true
    validates :protections, presence: true
  end
  