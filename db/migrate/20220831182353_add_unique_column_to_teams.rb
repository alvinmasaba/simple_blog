class AddUniqueColumnToTeams < ActiveRecord::Migration[7.0]
  def change
    change_column :teams, :name, :string, unique: true
  end
end
