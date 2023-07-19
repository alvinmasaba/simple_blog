# This migration creates the draft_picks table
class CreateDraftPicks < ActiveRecord::Migration[6.0]
  def change
    create_table :draft_picks do |t|
      t.references :team, null: false, foreign_key: true
      t.references :owned_by, null: false, foreign_key: { to_table: :teams }
      t.string :round
      t.integer :year
      t.string :protections

      t.timestamps
    end
  end
end
