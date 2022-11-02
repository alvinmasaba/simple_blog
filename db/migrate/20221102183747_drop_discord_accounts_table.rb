class DropDiscordAccountsTable < ActiveRecord::Migration[7.0]
  def change
    def up
      drop_table :discord_accounts
    end

    def down
      raise ActiveRecord::IrreversibleMigration
    end
  end
end
