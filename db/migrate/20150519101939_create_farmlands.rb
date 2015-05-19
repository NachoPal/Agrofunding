class CreateFarmlands < ActiveRecord::Migration
  def change
    create_table :farmlands do |t|

    	t.string :country
      t.string :community
      t.string :municipality
      t.string :region
      t.string :product
      t.float :price
      t.boolean :eco
      t.string :user_id
      t.string :usage
      t.date :period_start
      t.date :period_end
      t.float :geom_area
      t.float :rating
      t.integer :num_agrofunders
      t.column :geom_json, :json
      t.point :lonlat, geographic: true#4326
      t.timestamps

      t.timestamps null: false
    end

    change_table :farmlands do |t|
    t.index :lonlat, using: :gist
  	end
	end
end

