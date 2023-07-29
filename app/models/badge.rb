class Badge < ApplicationRecord
    has_many :player_badges
    has_many :players, through: :player_badges
  end
  