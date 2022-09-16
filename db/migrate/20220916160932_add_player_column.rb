class AddPlayerColumn < ActiveRecord::Migration[7.0]
  def change
    add_column :players, :suffix, :string
  end
end
