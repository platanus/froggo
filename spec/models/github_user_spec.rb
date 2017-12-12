require 'spec_helper'

RSpec.describe GithubUser, type: :model do
  describe "validations" do
    it { should validate_presence_of :gh_id }
    it { should validate_presence_of :login }
    it { should validate_presence_of :name }
  end
end
