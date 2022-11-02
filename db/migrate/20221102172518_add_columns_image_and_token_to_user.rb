class AddColumnsImageAndTokenToUser < ActiveRecord::Migration[7.0]
  def change
    change_table :users do |t|
      t.string :image
      t.string :token
    end
  end
end
