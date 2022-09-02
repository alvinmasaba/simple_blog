class AddColumnToPlayers < ActiveRecord::Migration[7.0]
  def change
    add_column :players, :draft_class, :integer
  end
end
