class Player < ApplicationRecord
  belongs_to :team
  has_one :contract

  validates :first_name, presence: true
  validates :last_name, presence: true

  def full_name
    "#{first_name.titleize} #{last_name.titleize}"
  end

  def add_name(player_name)
    update_name(player_name)
  end

  private

  def update_name(name)
    if name.length > 2
      self.first_name, self.last_name = name[0], (name[1] + '' + name[2])
    else
      self.first_name, self.last_name = name[0], name[1]
    end
  end
end
