require 'spec_helper'

describe GithubService do
  let (:admin_user) { create(:admin_user) }

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
          description:
            "We develop challenging software projects that require innovation and agility."
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
      expect(org.owner_id).to eq(admin_user.id)
      expect(org.gh_id).to eq(1158740)
      expect(org.name).to eq("Platanus")
      expect(org.avatar_url).to eq("https://avatars3.githubusercontent.com/u/1158740?v=4")
      expect(org.description).to eq(
        "We develop challenging software projects that require innovation and agility."
      )
    end
  end

  context "create_organization_repositories" do
    let (:owner) { create(:admin_user) }
    let (:organization) { create(:organization, owner_id: owner.id) }
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

      build.create_organization_repositories(organization)
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

  context 'create pull requests for repository' do
    let!(:repo) { create(:repository) }
    let!(:new_pull_request_data) do
      [
        double(
          id: 1,
          title: 'Test',
          number: 1,
          state: 'open',
          html_url: 'http://www.gihub.com/prueba',
          created_at: '2017-12-12 09:17:52',
          updated_at: '2017-12-12 09:17:52',
          closed_at: '2017-12-12 09:17:52',
          merged_at: '2017-12-12 09:17:52',
          assignees: []
        )
      ]
    end
    let!(:updated_pull_request_data) do
      [
        double(
          id: 1,
          title: 'Test',
          number: 1,
          state: 'closed',
          html_url: 'http://www.gihub.com/prueba',
          created_at: '2017-12-12 09:17:52',
          updated_at: '2017-12-14 09:17:52',
          closed_at: '2017-12-14 09:17:52',
          merged_at: '2017-12-14 09:17:52',
          assignees: [
            double(
              login: 'TestUser',
              id: 2,
              avatar_url: 'url_to_avatar',
              html_url: 'url_to_html'
            )
          ]
        )
      ]
    end
    let!(:new_reviews_data) do
      [
        double(
          user: double(
            login: 'ReviewerUser',
            id: 3,
            avatar_url: 'url_to_avatar',
            html_url: 'url_to_html'
          )
        )
      ]
    end

    let!(:updated_reviews_data) do
      [
        double(
          user: double(
            login: 'ReviewerUser',
            id: 3,
            avatar_url: 'url_to_avatar',
            html_url: 'url_to_html'
          )
        ),
        double(
          user: double(
            login: 'SecondReviewerUser',
            id: 4,
            avatar_url: 'url_to_avatar',
            html_url: 'url_to_html'
          )
        )
      ]
    end

    before do
      allow(OctokitClient).to receive(:fetch_repository_pull_requests)
        .and_return(new_pull_request_data)
      allow(OctokitClient).to receive(:fetch_pull_request_reviews).and_return(new_reviews_data)

      build.create_repository_pull_requests(repo.id, repo.full_name)
    end

    it 'saves the pull request' do
      pr = PullRequest.find_by(gh_id: 1)
      expect(pr).not_to be_nil
    end

    it 'saves the pull request with correct parameters' do
      pr = PullRequest.find_by(gh_id: 1)
      expect(pr.title).to eq('Test')
      expect(pr.gh_number).to eq(1)
      expect(pr.pr_state).to eq('open')
      expect(pr.gh_created_at).to eq('2017-12-12 09:17:52')
      expect(pr.gh_updated_at).to eq('2017-12-12 09:17:52')
      expect(pr.gh_closed_at).to eq('2017-12-12 09:17:52')
      expect(pr.gh_merged_at).to eq('2017-12-12 09:17:52')
    end

    it 'saves assignee users with correct parameters' do
      pr = PullRequest.find_by(gh_id: 1)
      pr_relation = pr.pull_request_relations.reviewers.first
      expect(pr_relation.pr_relation_type).to eq('reviewer')
      expect(pr_relation.github_user.gh_id).to eq(3)
      expect(pr_relation.github_user.login).to eq('ReviewerUser')
      expect(pr_relation.github_user.avatar_url).to eq('url_to_avatar')
      expect(pr_relation.github_user.html_url).to eq('url_to_html')
      expect(pr_relation.github_user.tracked).to eq(true)
    end

    it "don't duplicate existed pull requests" do
      build.create_repository_pull_requests(repo.id, repo.full_name)
      existed_pr = PullRequest.where(gh_id: 1)
      expect(existed_pr.count).to eq(1)
    end

    it 'updates existed pull requests if gh_updated_at is outdated' do
      allow(OctokitClient).to receive(:fetch_repository_pull_requests)
        .and_return(updated_pull_request_data)
      build.create_repository_pull_requests(repo.id, repo.full_name)
      pr = PullRequest.find_by(gh_id: 1)
      expect(pr.title).to eq('Test')
      expect(pr.gh_number).to eq(1)
      expect(pr.pr_state).to eq('closed')
      expect(pr.gh_created_at).to eq('2017-12-12 09:17:52')
      expect(pr.gh_updated_at).to eq('2017-12-14 09:17:52')
      expect(pr.gh_closed_at).to eq('2017-12-14 09:17:52')
      expect(pr.gh_merged_at).to eq('2017-12-14 09:17:52')
    end

    it 'saves assignee users with correct parameters' do
      allow(OctokitClient).to receive(:fetch_repository_pull_requests)
        .and_return(updated_pull_request_data)
      build.create_repository_pull_requests(repo.id, repo.full_name)
      pr = PullRequest.find_by(gh_id: 1)
      pr_relation = pr.pull_request_relations.assignees.first
      expect(pr_relation.pr_relation_type).to eq('assignee')
      expect(pr_relation.github_user.gh_id).to eq(2)
      expect(pr_relation.github_user.login).to eq('TestUser')
      expect(pr_relation.github_user.avatar_url).to eq('url_to_avatar')
      expect(pr_relation.github_user.html_url).to eq('url_to_html')
      expect(pr_relation.github_user.tracked).to eq(true)
    end

    it 'saves new reviewers users with correct parameters' do
      allow(OctokitClient).to receive(:fetch_repository_pull_requests)
        .and_return(updated_pull_request_data)
      allow(OctokitClient).to receive(:fetch_pull_request_reviews).and_return(updated_reviews_data)
      build.create_repository_pull_requests(repo.id, repo.full_name)
      pr = PullRequest.find_by(gh_id: 1)
      pr_relation = pr.pull_request_relations.reviewers.second
      expect(pr_relation.pr_relation_type).to eq('reviewer')
      expect(pr_relation.github_user.gh_id).to eq(4)
      expect(pr_relation.github_user.login).to eq('SecondReviewerUser')
      expect(pr_relation.github_user.avatar_url).to eq('url_to_avatar')
      expect(pr_relation.github_user.html_url).to eq('url_to_html')
      expect(pr_relation.github_user.tracked).to eq(true)
    end
  end
end
