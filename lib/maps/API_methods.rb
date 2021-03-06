def init 
	@farmlands_ids_retrieved = []
	@farmlands_in_boundary = []
	@features = []
end


def initialize_call?

	if(params[:init] == "true")
					Rails.cache.write(:ids, [])
					Rails.cache.write(:query_old, [params[:product], params[:eco], params[:order]])
	else
		query_new = [params[:product], params[:eco], params[:order]]

		unless(query_new == Rails.cache.read(:query_old))
			Rails.cache.write(:query_old, query_new)
			Rails.cache.clear(:ids)
			Rails.cache.write(:ids, [])
		end
	end
end


def get_query_values(action)

		if(action=="index")

			if(params[:product] == "all")
				@product = ["Tomate", "Uva", "Vino", "Esparrago", "Pimiento", "Lechuga", "Judia", "Alcachofa", "Zanahoria", "Patata"]
			else
				@product = params[:product]
			end

			if(params[:eco] == "all" || params[:eco] == "false")
				@eco = [true, false]
			else
				@eco = params[:eco]
			end

			@order_by = params[:order][0]
			@order_direction = params[:order][1]
		end

		if(action=="index" || action=="new")
			@boundarie_NE_lat = params[:b][0]
			@boundarie_NE_lon = params[:b][1]
			@boundarie_SW_lat = params[:b][2]
			@boundarie_SW_lon = params[:b][3]
		end
end

def create_polygon_boundaries

	map_polygon_gis = "POLYGON(("+ @boundarie_NE_lon +" "+ @boundarie_NE_lat +", "+
												@boundarie_SW_lon +" "+ @boundarie_NE_lat +", "+
												@boundarie_SW_lon +" "+ @boundarie_SW_lat +", "+
												@boundarie_NE_lon +" "+ @boundarie_SW_lat +", "+
												@boundarie_NE_lon +" "+ @boundarie_NE_lat +"))"

	map_polygon_object = RGeo::Geos.factory.parse_wkt(map_polygon_gis)
end

def farm_in_polygon?(map_polygon_object)

	@farmlands.each do |farm|

			unless(Rails.cache.read(:ids).include?(farm.id))
				if(map_polygon_object.contains?(farm.lonlat))
					@farmlands_in_boundary << farm
					@farmlands_ids_retrieved << farm.id
				end
			end
		end
end

def create_geojson(action)

	@farmlands_in_boundary.each do |farm|

		if(action=="index")
		
			farm.geom_json["properties"]["Producto"] = farm.product
			farm.geom_json["properties"]["Comunidad"] = farm.community
			farm.geom_json["properties"]["Municipio"] = farm.municipality
			farm.geom_json["properties"]["Region"] = farm.region
			farm.geom_json["properties"]["Area"] = farm.geom_area
			farm.geom_json["properties"]["Precio"] = farm.price
			farm.geom_json["properties"]["InicioTemporada"] = farm.period_start
			farm.geom_json["properties"]["FinalTemporada"] = farm.period_end
			farm.geom_json["properties"]["Id"] = farm.id
			farm.geom_json["properties"]["Nombre"] = farm.name
			farm.geom_json["properties"]["Descripcion"] = farm.description
			farm.geom_json["properties"]["Farmer"] = farm.farmer.name + farm.farmer.surname
			farm.geom_json["properties"]["Ecologico"] = farm.eco
		
		elsif(action=="new")
			if (farm.farmer)
				farm.geom_json["properties"]["Registrada"] = "Si";
			else
				farm.geom_json["properties"]["Registrada"] = "No";
				farm.geom_json["properties"]["Id"] = farm.id
				farm.geom_json["properties"]["Country"] = farm.country
				farm.geom_json["properties"]["Municipality"] = farm.municipality
				farm.geom_json["properties"]["Country"] = farm.country
				farm.geom_json["properties"]["Region"] = farm.region
			end
		end

		@features << farm.geom_json
	end
	
		@features
end

def send_geojson
	geo_json = {type: "FeatureCollection", features: @features}
  render json: geo_json
end