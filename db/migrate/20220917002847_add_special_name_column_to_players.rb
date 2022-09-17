class AddSpecialNameColumnToPlayers < ActiveRecord::Migration[7.0]
  def change
    add_column :players, :full_name, :string
  end
end
