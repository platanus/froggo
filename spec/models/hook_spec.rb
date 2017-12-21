require 'rails_helper'

RSpec.describe Hook, type: :model do
  describe "validations" do
    it { should validate_presence_of :gh_id }
    it { should belong_to(:resource) }
  end
end
