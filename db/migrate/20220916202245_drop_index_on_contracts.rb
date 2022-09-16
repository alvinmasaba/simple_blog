class DropIndexOnContracts < ActiveRecord::Migration[7.0]
  def change
    def change
      remove_index "contracts", column: ["player_id"], name: "index_contracts_on_player_id"
    end
  end
end
