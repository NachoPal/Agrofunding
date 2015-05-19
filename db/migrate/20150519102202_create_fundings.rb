class CreateFundings < ActiveRecord::Migration
  def change
    create_table :fundings do |t|

    	t.belongs_to :user, index: true
    	t.belongs_to :farmland, index: true
    	
      t.timestamps
    end
  end
end
