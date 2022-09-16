class Team < ApplicationRecord
  has_many :articles
  has_many :players
  has_many :contracts, through: :players
  
  validates :city, presence: true
  validates :name, presence: true, uniqueness: true
  
end
