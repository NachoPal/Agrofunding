class AddAmountColumnToFundings < ActiveRecord::Migration
  def change
  	add_column :fundings, :amount, :integer
  end
end
