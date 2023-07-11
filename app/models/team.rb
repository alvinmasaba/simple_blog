class Team < ApplicationRecord
  has_many :articles
  has_many :players, -> { includes(:contract).order("contracts.waived asc").order("contracts.year_1 desc") }, dependent: :destroy
  has_many :contracts, through: :players, dependent: :destroy
  belongs_to :user
  
  validates :city, presence: true
  validates :name, presence: true, uniqueness: true

  SALARY_CAP = 123655000
  
  def titleize_name
    "#{self.city.gsub("-", " ").titleize} #{self.name.gsub("-", " ").titleize}"
  end

  def yearly_salary_array
    [yearly_salary("year_1"), yearly_salary("year_2"), yearly_salary("year_3"),
     yearly_salary("year_4"), yearly_salary("year_5")]
  end

  private

  def yearly_salary(year)
    self.contracts.sum(year)
  end
end
