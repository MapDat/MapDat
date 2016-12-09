class Restaurant < ApplicationRecord
  has_many :map_object, through: :is_open
end
