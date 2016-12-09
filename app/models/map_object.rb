class MapObject < ApplicationRecord
  has_many :geo_points
  has_many :buildings
end
