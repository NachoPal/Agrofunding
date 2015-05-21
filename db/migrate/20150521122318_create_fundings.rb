class CreateFundings < ActiveRecord::Migration
  def change
    create_table :fundings do |t|

    	t.float :price_disccount
    	t.string :frecuency
    	t.belongs_to :agrofunder, index: true
    	t.belongs_to :farmland, index: true

      t.timestamps
    end
  end
end
