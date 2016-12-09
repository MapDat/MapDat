require 'rails_helper'

RSpec.describe GeoPoint, type: :model do
  it { should belong_to(:map_object) }
end
