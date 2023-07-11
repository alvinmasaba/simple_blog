class AddMoreCapFigures < ActiveRecord::Migration[7.0]
  def change
    add_column :cap_figures, :roommle, :int
    add_column :cap_figures, :nontaxpayermle, :int
    add_column :cap_figures, :taxpayermle, :int
    add_column :cap_figures, :bae, :int
  end
end
