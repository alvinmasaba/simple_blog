class AddRatingToPlayers < ActiveRecord::Migration[7.0]
  def change
    add_column :players, :rating, :integer
  end
end
