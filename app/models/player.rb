class Player < ApplicationRecord
  belongs_to :team
  has_one :contract

  validates :first_name, presence: true
  validates :last_name, presence: true

  def full_name
    full_name = "#{first_name.titleize} #{last_name.titleize}"
    
    suffix.nil? ? full_name : "#{full_name} #{suffix.titleize}"
  end

  def update_player_name(player_name)
    standardize_player_name(player_name)
  end

  private

  def standardize_player_name(name)
    name = name.downcase.split

    self.first_name, self.last_name, self.suffix = name[0], name[1]
    self.suffix = name[2] if name[2]
  end
end
