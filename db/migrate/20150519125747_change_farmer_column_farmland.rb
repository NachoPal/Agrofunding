class ChangeFarmerColumnFarmland < ActiveRecord::Migration
  def change
  	change_column :farmlands, :user_id, 'integer USING CAST(user_id AS integer)'

  end
end
