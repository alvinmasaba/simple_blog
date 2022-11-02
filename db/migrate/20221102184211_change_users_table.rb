class ChangeUsersTable < ActiveRecord::Migration[7.0]
  def change
    change_table :users do |t|
      t.remove :image
      t.remove :token
      t.remove :name
    end
  end
end
