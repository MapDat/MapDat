require 'rails_helper'

RSpec.describe IsOpen, type: :model do
  it { should belong_to(:map_object) }
  it { should belong_to(:restaurant) }
end
