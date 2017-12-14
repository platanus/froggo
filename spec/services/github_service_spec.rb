require 'spec_helper'

describe GithubService do
  let (:admin_user) { double }

  def build
    described_class.new(user: admin_user)
  end

  before do
    allow(admin_user).to receive(:token).and_return('thisistoken')
  end

  context "create_organizations" do
    before do
      allow(OctokitClient).to receive(:fetch_organizations).and_return(
        [{
          login: "platanus",
          id: 1158740,
          name: "Platanus",
          avatar_url: "https://avatars3.githubusercontent.com/u/1158740?v=4",
          description: "We develop challenging software projects that require innovation and agility."
        }]
      )

      build.create_organizations
    end

    it "saves the organizations" do
      org = Organization.find_by(login: "platanus")
      expect(org).not_to be_nil
    end

    it "saves the organizations with correct parameters" do
      org = Organization.find_by(login: "platanus")
      expect(org.login).to eq("platanus")
      expect(org.gh_id).to eq(1158740)
      expect(org.name).to eq("Platanus")
      expect(org.avatar_url).to eq("https://avatars3.githubusercontent.com/u/1158740?v=4")
      expect(org.description).to eq(
        "We develop challenging software projects that require innovation and agility."
      )
    end
  end

  context "create_organization_repositories" do
    before do
      allow(OctokitClient).to receive(:fetch_organization_repositories).and_return(
        [{
          id: 113467395,
          name: "gh-pr-stats",
          full_name: "platanus/gh-pr-stats",
          html_url: "https://github.com/platanus/gh-pr-stats",
          url: "https://api.github.com/repos/platanus/gh-pr-stats"
        }]
      )

      build.create_organization_repositories("platanus")
    end

    it "saves the repositories" do
      rep = Repository.find_by(name: "gh-pr-stats")
      expect(rep).not_to be_nil
    end

    it "saves the repositories with correct parameters" do
      rep = Repository.find_by(name: "gh-pr-stats")
      expect(rep.name).to eq("gh-pr-stats")
      expect(rep.full_name).to eq("platanus/gh-pr-stats")
      expect(rep.gh_id).to eq(113467395)
      expect(rep.html_url).to eq("https://github.com/platanus/gh-pr-stats")
      expect(rep.url).to eq("https://api.github.com/repos/platanus/gh-pr-stats")
    end
  end
end
