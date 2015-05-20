# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
Faker::Config.locale = :es
forbiden_usages = ["ZONA URBANA", "EDIFICACIONES", "FORESTAL",
                   "VIALES", "CORRIENTES Y SUP. DE AGUA"]
factory = RGeo::GeoJSON::EntityFactory.instance
factory2 = RGeo::Cartesian.factory
lonlat = 0
RGeo::Shapefile::Reader.open('/Users/Nacho/Desktop/IRONHACK/PROJECTO/agrofunding/db/shpfiles/Mun001.shp') do |file|
  puts "File contains #{file.num_records} records."
 j=0
  file.each do |record|
    # puts "Record number #{record.index}:"
    # puts "  Geometry: #{record.geometry.as_text}"
    # puts "  Attributes: #{record.attributes.inspect}"

    
    feature = factory.feature record.geometry
    hash = RGeo::GeoJSON.encode feature

    coord_srid25830 = hash["geometry"]["coordinates"][0][0]

    coord_srid25830.each_with_index do |coord,i|
    	
    	coord1 = coord[0]
    	coord2 = coord[1]

    	coord_srid4326 = `echo #{coord1} #{coord2} | cs2cs -f "%.6f" +init=epsg:25830 +to +init=epsg:4326`

    	coord_lat = coord_srid4326.split("\t")[1].to_f
   		coord_lon = coord_srid4326.split("\t")[0].to_f
   		#binding.pry
   		coord[0] = coord_lon;
   		coord[1] = coord_lat;
   		
   		if(i==0)
   			lonlat = factory2.point(coord_lat, coord_lon)
   			#puts lonlat
   		end
   	
    end
    #binding.pry
    farmland_geojson = hash.to_json
    

    if(j==0)
   	 		File.open('farm.json', 'w') {|file| file.write hash.to_json}
   	end
   	j=1

    #agricultor = Faker::Name.name
    producto = ["Tomate", "Uva", "Vino", "Esparrago", "Pimiento", "Lechuga", "Judia", "Alcachofa", "Zanahoria", "Patata", nil]
    date_init = Date.new(2016,rand(1..12),rand(1..29))
    eco = [true, false].sample
    price = rand(0.5..5.9).round(2)

    if forbiden_usages.include?(record.attributes["USO15"]) == false

   	Farmland.create(geom_json: farmland_geojson, country: "España", community: "Navarra",
   								  municipality: record.attributes["MUNICIPIO"], region: record.attributes["COMARCA"],
   								  geom_area: record.attributes["GEOM_AREA"], usage: record.attributes["USO15"],
   								  lonlat: lonlat, product: producto[rand(11)], price: price,
   								  period_start: date_init, period_end: date_init + rand(12).month, num_agrofunders: 0, eco: eco)
   	end
    
  end

  file.rewind
  record = file.next
  puts "First record geometry was: #{record.geometry.as_text}"
end
