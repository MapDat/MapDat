class MapObject < ApplicationRecord
  has_many :geo_point
  has_many :building
  has_many :poi
  has_many :restaurant, through: :is_open
end
