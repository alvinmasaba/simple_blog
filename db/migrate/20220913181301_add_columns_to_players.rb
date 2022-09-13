class AddColumnsToPlayers < ActiveRecord::Migration[7.0]
  def change
    add_column :players, :position, :string
    add_column :players, :height, :string
    
    add_index :players, [:position, :last_name]
    add_index :players, [:height, :last_name]
    add_index :players, [:age, :last_name]
    add_index :players, :last_name
  end
end
