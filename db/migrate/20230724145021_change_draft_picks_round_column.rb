class ChangeDraftPicksRoundColumn < ActiveRecord::Migration[7.0]
  def change
    change_column :draft_picks, :round, :integer
  end
end
