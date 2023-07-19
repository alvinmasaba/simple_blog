class CreateTradeExceptions < ActiveRecord::Migration[6.0]
  def change
    create_table :trade_exceptions do |t|
      t.references :team, null: false, foreign_key: true
      t.integer :amount
      t.datetime :expiry
      t.string :exception_type

      t.timestamps
    end
  end
end
