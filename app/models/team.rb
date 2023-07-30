class Team < ApplicationRecord
  has_many :articles
  has_many :assets
  has_many :players, -> { includes(:contract).order("contracts.waived asc").order("contracts.year_1 desc") }, dependent: :destroy
  has_many :contracts, through: :players, dependent: :destroy
  belongs_to :user, optional: true
  
  validates :city, presence: true
  validates :name, presence: true, uniqueness: true

  def titleize_name
    "#{self.city.gsub("-", " ").titleize} #{self.name.gsub("-", " ").titleize}"
  end

  def yearly_salary_array
    [yearly_salary("year_1"), yearly_salary("year_2"), yearly_salary("year_3"),
     yearly_salary("year_4"), yearly_salary("year_5")]
  end

  def logo
    # Returns path to team logo
    city.downcase + "-" + name.downcase + '.svg'
  end

  def secondary_logo
    'secondary_logos/' + name.downcase + '.svg'
  end

  def current_payroll
    sum = 0

    self.contracts.each do |contract|
      sum += contract["year_1"]
    end

    sum
  end

  def cap_room(current_year)
    CapFigure.find_by(year: current_year).salary_cap - current_payroll
  end

  def over_apron?(current_year)
    self.current_payroll > CapFigure.find_by(year: current_year).apron ? true : false
  end

  def roster_size
    players.count
  end

  private

  def yearly_salary(year)
    self.contracts.sum(year)
  end
end
