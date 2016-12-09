# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
ActiveRecord::Base.establish_connection
ActiveRecord::Base.connection.tables.each do |table|
  next if table == 'schema_migrations'

  # MySQL and PostgreSQL
  ActiveRecord::Base.connection.execute("TRUNCATE #{table}")

  # SQLite
  # ActiveRecord::Base.connection.execute("DELETE FROM #{table}")
end

num_users = 500
num_reviews = 5000

# Seed buildings into the database

if ENV["objects"]
  # Get the buildings from the campus map
  uri = URI.parse('http://campusmap.ufl.edu/library/cmapjson/geo_buildings.json')
  response = Net::HTTP.get(uri)
  data = JSON.parse(response)
  geo_buildings = []

  # Build a hash for each building
  data['features'].each do |feature|
    props = feature['properties']
    jtype = props['JTYPE']
    bldg_num = props['BLDG']
    abbrev = props['ABBREV']
    name = props['NAME']
    address = props['ADDRESS1']
    city = props['CITY']
    state = props['STATE']
    zip = props['ZIP']

    description = props['DESCRIPTION'].gsub(/'/, ' ')

    url = props['URL']
    photo = props['PHOTO']

    shape =  feature['geometry']['type']
    points = []
    # puts "ITEM: "
    feature['geometry']['coordinates'][0].each do |point|
      if shape == 'Polygon'

        points << [point[1], point[0]] # latitude, longitude
        # puts "#{point[1]}, #{point[0]}"
      end
    end


    prop_hash = { jtype: jtype, bldg_num: bldg_num, abbrev: abbrev,
                  address: address, city: city, state: state,
                  zip: zip, desc: description, url: url,
                  remote_photo_path: photo, geo_points: points,
                  name: name }

   # puts prop_hash
    geo_buildings << prop_hash
  end

  # Insert map objects, buildings, and geo_points
  object_progress = ProgressBar.create(title: "Buildings",
                                       total: geo_buildings.count,
                                       format: "%t: %B | Time Left: %E | Rate: %r | %c/%C")
  geo_buildings.each do |geo_building|
    map_object = MapObject.create(name: geo_building[:name],
                                  abbrev: geo_building[:abbrev],
                                  description: geo_building[:desc],
                                  image_path: geo_building[:remote_photo_path])

    map_object.building.create(outlets: 0,
                               computers: false,
                               study_space: false,
                               floors: 0)

    geo_building[:geo_points].each do |geo_point|
       map_object.geo_point.create(longitude: geo_point[1], latitude: geo_point[0])
    end
    object_progress.increment
  end

  # Seed points of interest
  # Currently urban parks and natural areas are the only POI

  # Get urban parks from the campus map
  uri = URI.parse('http://campusmap.ufl.edu/library/cmapjson/urban_parks.json')
  response = Net::HTTP.get(uri)
  data = JSON.parse(response)
  geo_pois = []

  # Build a hash for each item
  data['features'].each do |feature|
    props = feature['properties']
    name = props['NAME']
    type = props['JTYPE']
    description = props['DESCRIPTION']
    shape = feature['geometry']['type']
    points = []

    # puts "ITEM: "
    feature['geometry']['coordinates'][0].each do |point|
      if shape == 'Polygon'

        points << [point[1], point[0]] # latitude, longitude
        # puts "#{point[1]}, #{point[0]}"
      end
    end

    prop_hash = { name: name, desc: description, type: type, geo_points: points }
    #puts prop_hash
    geo_pois << prop_hash
  end

  #Natural areas
  # Get natural areas from campus map
  uri = URI.parse('http://campusmap.ufl.edu/library/cmapjson/natural_areas.json')
  response = Net::HTTP.get(uri)
  data = JSON.parse(response)

  # Build a hash for each item
  data['features'].each do |feature|
    props = feature['properties']
    name = props['NAME']
    type = props['JTYPE']
    description = props['DESCRIPTION']
    shape = feature['geometry']['type']
    photo = props['PHOTO']
    points = []

    # puts "ITEM: "
    feature['geometry']['coordinates'][0].each do |point|
      if shape == 'Polygon'
        points << [point[1], point[0]] # latitude, longitude
        # puts "#{point[1]}, #{point[0]}"
      end
    end

    prop_hash = { name: name, desc: description, type: type, photo: photo, geo_points: points }
    #puts prop_hash
    geo_pois << prop_hash
  end

  poi_progress = ProgressBar.create(title: "Points of Interest",
                                       total: geo_pois.count,
                                       format: "%t: %B | Time Left: %E | Rate: %r | %c/%C")
  # Insert map objects and points of interest
  geo_pois.each do |geo_poi|
    map_object = MapObject.create(name: geo_poi[:name],
                                  description: geo_poi[:desc],
                                  image_path: geo_poi[:photo])

    map_object.poi.create(poi_type: geo_poi[:type])

    geo_poi[:geo_points].each do |geo_point|
      map_object.geo_point.create(longitude: geo_point[1], latitude: geo_point[0])
    end
    poi_progress.increment
  end
end

if ENV["restaurants"]

  # RESTAURANTS
  restaurants = YAML.load_file("#{Rails.root}/db/restaurants.yml")
  i = 0
  restaurants.each do |key, value|
  #  puts restaurants[key]
    object_id = @connection.exec_query("SELECT m.id FROM map_object m
                                        WHERE m.abbrev = '#{restaurants[key]['Location']}'")

    object_id = object_id.first["id"]
    puts key
    open_hours = []
    restaurants[key].each do |key, value|
      next if key == 'Location'
      day = Day.new(key, value["open"], value["close"])
      open_hours << day
      puts value["open"].to_s + ' ' + value["close"].to_s
    end

    begin
      Restaurant_Seed.new(i, key, '', '', object_id, open_hours)
    rescue => error
      puts error
      print '_'
    end

    i += 1
    #Restaurant.new restaurant[key], '', '',
  end
end
