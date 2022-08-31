class AddTeamReferenceToArticles < ActiveRecord::Migration[7.0]
  def change
    add_reference :articles, :team, foreign_key: true
  end
end
