class AddNameColumnToFarmlands < ActiveRecord::Migration
  def change
  	add_column :farmlands, :name, :string
  end
end
