class AddAssetableToAssets < ActiveRecord::Migration[7.0]
  def change
    create_table :assets do |t|
      t.references :assetable, polymorphic: true, null: false
      t.references :team, null: false, foreign_key: true

      t.timestamps
    end
  end
end
