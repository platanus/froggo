require 'rails_helper'

RSpec.describe Hook, type: :model do
  describe "validations" do
    it { should validate_presence_of :gh_id }
    it { should validate_presence_of :repository_id }
    it { should validate_presence_of :active }
  end
end
