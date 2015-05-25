class RemoveColumnUsageFromFarmlands < ActiveRecord::Migration
  def change
  	remove_column :farmlands, :usage, :string
  end
end
