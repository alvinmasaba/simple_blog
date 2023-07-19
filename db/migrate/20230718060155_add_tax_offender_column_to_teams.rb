class AddTaxOffenderColumnToTeams < ActiveRecord::Migration[7.0]
  def change
    add_column :teams, :tax_offender, :integer
  end
end
