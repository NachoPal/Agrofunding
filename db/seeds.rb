Faker::Config.locale = :es

#========================= USERS ===================================

for i in 0..3000

  name = Faker::Name.first_name
  surname = Faker::Name.last_name
  community = "Navarra"
  municipality = ["Ablitas", "Arguedas", "Bardenas Reales", "Bardillas", "Buñuel", "Cabanillas", "Cascante", "Castejón",
                  "Cintruénigo", "Corella", "Cortes", "Fitero", "Fontellas", "Fustiñana", "Monteagudo", "Murchante", "Ribaforada",
                  "Tudela", "Tulebras", "Valtirra"].sample
  city = Faker::Address.city
  address = Faker::Address.street_address
  postal_code = Faker::Address.zip_code
  telephone = Faker::PhoneNumber.cell_phone
  company = Faker::Company.name
  type = ["Farmer", "Agrofunder"].sample
  description = Faker::Lorem.paragraph(5)
  email = "user"+i.to_s+"@gmail.com"
  password = "12345678"
  password_confirmation = "12345678"
  #avatar = gravatar_image_tag('spam@spam.com'.gsub('spam', 'mdeering'), :alt => 'Michael Deering')

  User.create(name: name, surname: surname, community: community, municipality: municipality, city: city, address: address,
              postal_code: postal_code, telephone: telephone, company: company, type: type, description: description,
              email: email, password: password, password_confirmation: password_confirmation)
end

#========================= FARMLANDS ===================================

factory = RGeo::GeoJSON::EntityFactory.instance
#factory2 = RGeo::Cartesian.factory
lonlat = 0
shape_file = Dir['/Users/Nacho/Desktop/IRONHACK/PROJECTO/agrofunding/db/shpfiles/Mun001/*.shp']
forbiden_usages = ["ZONA URBANA", "EDIFICACIONES", "FORESTAL",
                   "VIALES", "CORRIENTES Y SUP. DE AGUA", "IMPRODUCTIVOS"]

RGeo::Shapefile::Reader.open(shape_file[0]) do |file|
  #puts "File contains #{file.num_records} records."
  j=0

  file.each do |record|

    feature = factory.feature record.geometry
    hash = RGeo::GeoJSON.encode feature
    coord_srid25830 = hash["geometry"]["coordinates"][0][0]

    coord_srid25830.each_with_index do |coord,i|
    	
    	coord1 = coord[0]
    	coord2 = coord[1]

    	coord_srid4326 = `echo #{coord1} #{coord2} | cs2cs -f "%.6f" +init=epsg:25830 +to +init=epsg:4326`

    	coord_lat = coord_srid4326.split("\t")[1].to_f
   		coord_lon = coord_srid4326.split("\t")[0].to_f

   		coord[0] = coord_lon;
   		coord[1] = coord_lat;
   		
   		if(i==0)
   			#lonlat = factory2.point(coord_lat, coord_lon)
        lonlat = RGeo::Geographic.spherical_factory(:srid => 4326).point(coord_lon, coord_lat)
   		end
   	
    end

    farmland_geojson = hash.to_json
    
    if(j==0)
   	 		File.open('farm.json', 'w') {|file| file.write hash.to_json}
   	end
   	j=1

    farmers = Farmer.all
    farmers_id = []

    farmers.each do |farmer|
      farmers_id << farmer.id
    end

    for i in (1..farmers.size/3)
      farmers_id << nil
    end

    farmer_id = farmers_id.sample

    if forbiden_usages.include?(record.attributes["USO15"]) == false

      if farmer_id 

        producto = ["Tomate", "Uva", "Vino", "Esparrago", "Pimiento", "Lechuga", "Judia", "Alcachofa", "Zanahoria", "Patata"]
        date_init = Date.new(2015,rand(1..12),rand(1..25))
        eco = [true, false].sample
        price = rand(1.5..5.9).round(2)
        word = Faker::Lorem.word
        description = Faker::Lorem.paragraph(20)

        

       	farm = Farmland.create(geom_json: farmland_geojson, country: "España", community: "Navarra",
       								  municipality: record.attributes["MUNICIPIO"], region: record.attributes["COMARCA"],
       								  geom_area: record.attributes["GEOM_AREA"], name: "Tierra " + word,
       								  lonlat: lonlat, product: producto.sample, price: price,period_start: date_init, 
                        period_end: date_init + rand(12).month, eco: eco, description: description)

        farm.farmer = User.find(farmer_id)
        farm.save

        agrofunders = Agrofunder.all
        agrofunders_id = []
        frecuency = ["Quincenal", "Mensual", "Trimestral", "Semestral", "Anual"]

        agrofunders.each do |agrofunder|
          agrofunders_id << agrofunder.id
        end

        #agrofunder_id = agrofunders_id.sample

        # index = rand(agrofunders_id.size/2)
        # agrofunders_id_to_fund = (1..rand(agrofunders_id.size)).to_a[index..rand((agrofunders_id.size))]
        
        agrofunders_id.each do |id|
          if(rand(800) < 2)
            farm.agrofunders << Agrofunder.find(id)
            funding = Funding.where(agrofunder: id, farmland: farm.id).first
            funding.frecuency = frecuency.sample
            price_disccount = rand(0.01..1.1).round(2)
            amount = rand(1..20)
            funding.amount = amount
            funding.price_disccount = price_disccount
            funding.save
          end
        end

      else

        Farmland.create(geom_json: farmland_geojson, country: "España", community: "Navarra",
                        municipality: record.attributes["MUNICIPIO"], region: record.attributes["COMARCA"],
                        geom_area: record.attributes["GEOM_AREA"], lonlat: lonlat)
      end
    end
  end
  file.rewind
  record = file.next
  #puts "First record geometry was: #{record.geometry.as_text}"
end
