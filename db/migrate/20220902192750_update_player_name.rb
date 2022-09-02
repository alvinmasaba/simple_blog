class UpdatePlayerName < ActiveRecord::Migration[7.0]
  def change
    remove_column :players, :name, :string
    add_column :players, :first_name, :string
    add_column :players, :last_name, :string
  end
end
