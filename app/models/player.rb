class Player < ApplicationRecord
  belongs_to :team
  has_many :contracts, :dependent => :destroy

  validates :first_name, presence: true
  validates :last_name, presence: true

  def full_name
    full_name = "#{first_name.titleize} #{last_name.titleize}"
    
    suffix.nil? ? full_name : "#{full_name} #{standardize_suffix(suffix)}"
  end

  def ratings_url
    base = "https://www.2kratings.com/#{first_name}-#{last_name}"

    suffix.nil? ? base : base + "-#{suffix}"
  end

  def update_player_name(player_name)
    standardize_player_name(player_name)
  end

  def standardize_suffix(suffix)
    suffix == "jr." || suffix == "sr." ? suffix.titleize : suffix.upcase
  end

  private

  def standardize_player_name(name)
    self.first_name, self.last_name = name[0], name[1]
    self.suffix = name[2] if name[2]
  end
end
