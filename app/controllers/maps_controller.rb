class MapsController < ApplicationController

	def index
		features = []

		farmlands = Farmland.all
		puts params[:status]; 
		farmlands.each do |farm|
			#farm.geom_json["properties"]["Agricultor"] = farm.owner
			farm.geom_json["properties"]["Producto"] = farm.product
			farm.geom_json["properties"]["Comunidad"] = farm.community
			farm.geom_json["properties"]["Municipio"] = farm.municipality
			farm.geom_json["properties"]["Region"] = farm.region
			farm.geom_json["properties"]["Area"] = farm.geom_area

			if (farm.geom_json["properties"]["Producto"])
				features << farm.geom_json
			end
		end

		geo_json = {type: "FeatureCollection",
    features: features}

    render json: geo_json
	end

end
