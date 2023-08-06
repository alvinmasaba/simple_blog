class AddDivisionToTeams < ActiveRecord::Migration[7.0]
  def change
    add_column :teams, :division, :string
  end
end
