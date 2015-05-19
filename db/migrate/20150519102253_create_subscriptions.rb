class CreateSubscriptions < ActiveRecord::Migration
  def change
    create_table :subscriptions do |t|

    	t.integer :amount
    	t.string :frecuency
    	t.belongs_to :agrofunder, index: true
    	t.belongs_to :farmland, index: true

      t.timestamps
    end
  end
end
