class AddColorsToTeams < ActiveRecord::Migration[7.0]
  def change
    add_column :teams, :primary_color, :string, default: "#1D42BA"
    add_column :teams, :secondary_color, :string, default: "#002D62"
    add_column :teams, :tertiary_color, :string, default: "#C8102E"
  end
end
