require './lib/maps/API_methods.rb'

class MapsController < ApplicationController

	def index
	
		init

		initialize_call?

		get_query_values("index")

		map_polygon_object = create_polygon_boundaries

		@farmlands = Farmland.where.not(farmer_id: nil).where(product: @product, eco: @eco)
												.order(params[:order][0] => params[:order][1].to_sym)

		farm_in_polygon?(map_polygon_object)
		
		create_geojson("index") 

		Rails.cache.write(:ids, @farmlands_ids_retrieved + Rails.cache.read(:ids))
	
		send_geojson
	end


	def new

		init

		if(params[:init] == "true")
				Rails.cache.write(:ids, [])
		end

		get_query_values("new")

		map_polygon_object = create_polygon_boundaries

		@farmlands = Farmland.all

		farm_in_polygon?(map_polygon_object)
		
		create_geojson("new")

		Rails.cache.write(:ids, @farmlands_ids_retrieved + Rails.cache.read(:ids))
	
		send_geojson
	end

end
