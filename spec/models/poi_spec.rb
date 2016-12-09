require 'rails_helper'

RSpec.describe Poi, type: :model do
  it { should belong_to(:map_object) }
end
