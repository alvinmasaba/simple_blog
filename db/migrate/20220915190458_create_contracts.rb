class CreateContracts < ActiveRecord::Migration[7.0]
  def change
    create_table :contracts do |t|
      t.integer :year_1
      t.integer :year_2
      t.integer :year_3
      t.integer :year_4
      t.integer :year_5
      t.integer :year_6

      t.integer :player_option
      t.integer :team_option

      t.references :player, null: false, foreign_key: true

      t.timestamps
    end
  end
end
