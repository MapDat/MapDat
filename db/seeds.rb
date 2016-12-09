# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
num_users = 500
num_reviews = 5000

# Seed buildings into the database

if ENV["objects"]
  puts 'Seeding buildings'
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
  geo_buildings.each do |geo_building|
    map_object = MapObject.create(name: geo_building[:name],
                                  abbrev: geo_building[:abbrev],
                                  description: geo_building[:desc],
                                  image_path: geo_building[:remote_photo_path])

    map_object.buildings.create(
                               outlets: 0,
                               computers: false,
                               study_space: false,
                               floors: 0)

    puts geo_building[:name]

    geo_building[:geo_points].each do |geo_point|
       map_object.geo_points.create(longitude: geo_point[1], latitude: geo_point[0])
     end
  end
end
