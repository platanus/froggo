require 'rails_helper'

RSpec.describe Organization, type: :model do
  describe "validations" do
    it { should validate_presence_of :ghid }
    it { should validate_presence_of :login }
  end
end
