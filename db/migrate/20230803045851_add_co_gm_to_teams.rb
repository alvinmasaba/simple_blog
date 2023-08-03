class AddCoGmToTeams < ActiveRecord::Migration[7.0]
  def change
    add_column :teams, :co_gm_id, :integer
  end
end
