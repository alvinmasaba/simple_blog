class AddWeightToPlayers < ActiveRecord::Migration[7.0]
  def change
    add_column :players, :weight, :integer
  end
end
