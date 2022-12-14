class Contract < ApplicationRecord
  belongs_to :player
  belongs_to :team

  def update_salary(salary, num)
    case num
    when 1
      self.year_1 = salary
    when 2
      self.year_2 = salary
    when 3
      self.year_3 = salary
    when 4
      self.year_4 = salary
    when 5
      self.year_5 = salary
    when 6
      self.year_6 = salary
    end
  end

  def contract_array
    [year_1, year_2, year_3, year_4, year_5, year_6]
  end
end
