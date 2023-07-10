class CreateCapFigures < ActiveRecord::Migration[7.0]
  def change
    create_table :cap_figures do |t|
      t.integer :salary_cap
      t.integer :luxury_tax
      t.integer :apron
      t.integer :second_apron
      t.integer :min_payroll
      t.integer :cap_hold

      t.timestamps
    end
  end
end
