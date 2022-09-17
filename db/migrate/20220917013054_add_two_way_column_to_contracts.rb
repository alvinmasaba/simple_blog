class AddTwoWayColumnToContracts < ActiveRecord::Migration[7.0]
  def change
    add_column :contracts, :two_way, :boolean

    add_column :contracts, :waived, :boolean
  end
end
