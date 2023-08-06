class AddGmToTeams < ActiveRecord::Migration[7.0]
  def change
    add_reference :teams, :gm, foreign_key: { to_table: :users }
  end
end
