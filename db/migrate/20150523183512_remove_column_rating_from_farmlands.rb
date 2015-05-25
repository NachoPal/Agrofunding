class RemoveColumnRatingFromFarmlands < ActiveRecord::Migration
  def change
  	remove_column :farmlands, :rating, :float
  end
end
