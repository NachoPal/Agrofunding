class AddColumnDescriptionToFarmlands < ActiveRecord::Migration
  def change
  	add_column :farmlands, :description, :text
  end
end
