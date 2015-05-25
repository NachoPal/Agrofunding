class RemoveColumnWebsiteFromUsers < ActiveRecord::Migration
  def change
  	remove_column :users, :website, :string
  end
end
