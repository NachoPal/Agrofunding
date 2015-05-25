class RemoveColumnAgrofundersNumFromFarmlands < ActiveRecord::Migration
  def change
  	remove_column :farmlands, :num_agrofunders, :integer
  end
end
