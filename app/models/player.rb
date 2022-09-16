class Player < ApplicationRecord
  belongs_to :team
  has_many :contracts, :dependent => :destroy

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
    self.first_name, self.last_name = name[0], name[1]
    self.suffix = name[2] if name[2]
  end
end
