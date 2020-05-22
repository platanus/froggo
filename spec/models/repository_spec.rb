require 'rails_helper'

RSpec.describe Repository, type: :model do
  describe "validations" do
    it { should validate_presence_of :gh_id }
    it { should validate_presence_of :full_name }
  end
end
