class RemoveTeamIdFromArticles < ActiveRecord::Migration[7.0]
  def change
    remove_column :articles, :team_id, :integer
  end
end
