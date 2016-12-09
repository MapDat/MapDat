require 'rails_helper'

RSpec.describe Building, type: :model do
  it { should belong_to(:map_object) }
end
