class MapsController < ApplicationController

	def index
		#Rails.cache.clear(:ids)
		features = []
		farmlands_ids_retrieved = []
		puts "HoOLA"
		if(params[:init] == "true")

			#binding.pry
			Rails.cache.write(:ids, [])
			#binding.pry
			Rails.cache.write(:query_old, [params[:product], params[:eco], params[:order]])
		else
			query_new = [params[:product], params[:eco], params[:order]]

			unless(query_new == Rails.cache.read(:query_old))
				Rails.cache.write(:query_old, query_new)
				#binding.pry
				Rails.cache.clear(:ids)
			end
		end

		if(params[:product] == "all")
			product = ["Tomate", "Uva", "Vino", "Esparrago", "Pimiento", "Lechuga", "Judia", "Alcachofa", "Zanahoria", "Patata"]
		else
			product = params[:product]
		end

		if(params[:eco] == "all")
			eco = [true, false]
		else
			eco = params[:eco]
		end

		#eco = params[:eco]
		order_by = params[:order][0]
		order_direction = params[:order][1]
		boundarie_NE_lat = params[:b][0]
		boundarie_NE_lon = params[:b][1]
		boundarie_SW_lat = params[:b][2]
		boundarie_SW_lon = params[:b][3]

		# lat < NE_lat, lat > SW_lat
		# lon < NE_lon, lon > SW_lon
		map_polygon_gis = "POLYGON(("+ boundarie_NE_lon +" "+ boundarie_NE_lat +", "+
											boundarie_SW_lon +" "+ boundarie_NE_lat +", "+
											boundarie_SW_lon +" "+ boundarie_SW_lat +", "+
											boundarie_NE_lon +" "+ boundarie_SW_lat +", "+
											boundarie_NE_lon +" "+ boundarie_NE_lat +"))"
		
		map_polygon_object = RGeo::Geos.factory.parse_wkt(map_polygon_gis)
		
		#line_boundary = map_polygon_object.boundary

		#polygon_object = RGeo::Geos.factory.parse_wkt("POLYGON((-149.737965876574 61.1952881991104, -149.71848377896 61.1953198415937, -149.718483761252 61.1952938698801, -149.718483872402 61.1951924591105, -149.737965876574 61.1952881991104))")
	
		farmlands = Farmland.where.not(farmer_id: nil).where(product: product, eco: eco)
												.order(params[:order][0] => params[:order][1].to_sym)

		#farmlands = Farmland.all
		
		farmlands_in_boundary = []

		#binding.pry
		farmlands.each do |farm|
			#binding.pry
			unless(Rails.cache.read(:ids).include?(farm.id))
				if(map_polygon_object.contains?(farm.lonlat))
					farmlands_in_boundary << farm
					farmlands_ids_retrieved << farm.id
				end
			end
		end			


		
		farmlands_in_boundary.each do |farm|
			#farm.geom_json["properties"]["Agricultor"] = farm.owner
			farm.geom_json["properties"]["Producto"] = farm.product
			farm.geom_json["properties"]["Comunidad"] = farm.community
			farm.geom_json["properties"]["Municipio"] = farm.municipality
			farm.geom_json["properties"]["Region"] = farm.region
			farm.geom_json["properties"]["Area"] = farm.geom_area
			farm.geom_json["properties"]["Precio"] = farm.price
			farm.geom_json["properties"]["Inicio temporada"] = farm.period_start
			farm.geom_json["properties"]["Final temporada"] = farm.period_end
			farm.geom_json["properties"]["Id"] = farm.id


			#if (farm.geom_json["properties"]["Producto"])
				features << farm.geom_json
			#end
		end
		#binding.pry
		#ids = Rails.cache.read(:ids)
		#binding.pry
		# ids.each do |id|
		# 	farmlands_ids_retrieved << id
		# end
		#binding.pry

		Rails.cache.write(:ids, farmlands_ids_retrieved + Rails.cache.read(:ids))
		
		#binding.pry
		geo_json = {type: "FeatureCollection",
    features: features}

    render json: geo_json
	end

	# def inside_boundaries?


	# end


	#end

end
