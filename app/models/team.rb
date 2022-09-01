class Team < ApplicationRecord
  has_many :articles
  
  validates :city, presence: true
  validates :name, presence: true, uniqueness: true
  
end
