class Team < ApplicationRecord
  has_many :articles
  has_many :players
  
  validates :city, presence: true
  validates :name, presence: true, uniqueness: true
  
end
