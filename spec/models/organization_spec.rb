require 'spec_helper'

RSpec.describe Organization, type: :model do
  describe "validations" do
    it { should validate_presence_of :gh_id }
    it { should validate_presence_of :login }
    it { should validate_presence_of :name }
  end
end
