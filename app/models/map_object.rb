class MapObject < ApplicationRecord
  has_many :geo_point
  has_many :building
end
