class AddYearToCapFigures < ActiveRecord::Migration[7.0]
  def change
    add_column :cap_figures, :year, :string
  end
end
