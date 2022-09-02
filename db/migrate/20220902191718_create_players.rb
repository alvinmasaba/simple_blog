class CreatePlayers < ActiveRecord::Migration[7.0]
  def change
    create_table :players do |t|
      t.string :name
      t.integer :age
      t.string :school
      t.string :country
      t.integer :years_in_league
      t.references :team, null: true, foreign_key: true

      t.timestamps
    end
  end
end
