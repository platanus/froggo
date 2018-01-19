require 'spec_helper'

describe GithubService do
  let (:admin_user) { create(:admin_user) }

  def build
    described_class.new(user_token: admin_user.token, user_id: admin_user.id)
  end

  before do
    allow(admin_user).to receive(:token).and_return('thisistoken')
  end

  context "create_organizations" do
    before do
      allow_any_instance_of(Octokit::Client).to receive(:orgs).and_return(
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
      allow_any_instance_of(Octokit::Client).to receive(:org_repos).and_return(
        [{
          id: 113467395,
          name: "froggo",
          full_name: "platanus/froggo",
          html_url: "https://github.com/platanus/froggo",
          url: "https://api.github.com/repos/platanus/froggo"
        }]
      )

      build.create_organization_repositories(organization)
    end

    it "saves the repositories" do
      rep = Repository.find_by(name: "froggo")
      expect(rep).not_to be_nil
    end

    it "saves the repositories with correct parameters" do
      rep = Repository.find_by(name: "froggo")
      expect(rep.name).to eq("froggo")
      expect(rep.full_name).to eq("platanus/froggo")
      expect(rep.gh_id).to eq(113467395)
      expect(rep.html_url).to eq("https://github.com/platanus/froggo")
      expect(rep.url).to eq("https://api.github.com/repos/platanus/froggo")
    end
  end

  context 'pull requests repository' do
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
          merged_at: nil,
          user: double(
            id: 1,
            login: 'bunzli',
            avatar_url: 'https://avatars2.githubusercontent.com/u/741483?v=4',
            html_url: 'https://github.com/bunzli'
          )
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

    before do
      allow_any_instance_of(Octokit::Client).to receive(:pull_requests)
        .and_return(new_pull_request_data)
      allow_any_instance_of(Octokit::Client).to receive(:pull_request_reviews)
        .and_return(new_reviews_data)

      build.create_repository_pull_requests(repo.id, repo.full_name)
    end

    context 'create' do
      it 'saves the pull request' do
        pr = PullRequest.find_by(gh_id: 1)
        expect(pr).not_to be_nil
      end

      it 'the pull request with correct parameters' do
        pr = PullRequest.find_by(gh_id: 1)
        expect(pr.title).to eq('Test')
        expect(pr.gh_number).to eq(1)
        expect(pr.pr_state).to eq('open')
        expect(pr.gh_created_at).to eq('2017-12-12 09:17:52')
        expect(pr.gh_updated_at).to eq('2017-12-12 09:17:52')
        expect(pr.gh_closed_at).to eq('2017-12-12 09:17:52')
        expect(pr.gh_merged_at).to be_nil
      end

      it 'reviewer with correct parameters' do
        pr = PullRequest.find_by(gh_id: 1)
        pr_relation = pr.pull_request_relations.reviewers.first
        expect(pr_relation.pr_relation_type).to eq('reviewer')
        expect(pr_relation.github_user.gh_id).to eq(3)
        expect(pr_relation.github_user.login).to eq('ReviewerUser')
        expect(pr_relation.github_user.avatar_url).to eq('url_to_avatar')
        expect(pr_relation.github_user.html_url).to eq('url_to_html')
        expect(pr_relation.github_user.tracked).to eq(true)
      end
    end

    context 'update' do
      let!(:created_pr) { PullRequest.find_by(gh_id: 1) }
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
            merge_commit_sha: 'commit-sha',
            user: double(
              id: 1,
              login: 'bunzli',
              avatar_url: 'https://avatars2.githubusercontent.com/u/741483?v=4',
              html_url: 'https://github.com/bunzli'
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

      let!(:commit_data) do
        double(
          author: double(
            id: 5,
            login: 'MergeUser',
            avatar_url: 'url_to_avatar',
            html_url: 'url_to_html'
          )
        )
      end

      before do
        allow_any_instance_of(Octokit::Client).to receive(:pull_requests)
          .and_return(updated_pull_request_data)
        allow_any_instance_of(Octokit::Client).to receive(:commit).and_return(commit_data)
        allow_any_instance_of(Octokit::Client).to receive(:pull_request_reviews)
          .and_return(updated_reviews_data)

        build.create_repository_pull_requests(repo.id, repo.full_name)
        created_pr.reload
      end

      it "don't duplicate existed pull requests" do
        existed_pr = PullRequest.where(gh_id: 1)
        expect(existed_pr.count).to eq(1)
      end

      it 'merge data with correct parameters' do
        merge_user = GithubUser.find_by(gh_id: 5)
        pr_relation = created_pr.pull_request_relations.merged_by
                                .find_by(github_user_id: merge_user.id)
        expect(pr_relation.pr_relation_type).to eq('merge_by')
        expect(merge_user.login).to eq('MergeUser')
        expect(merge_user.avatar_url).to eq('url_to_avatar')
        expect(merge_user.html_url).to eq('url_to_html')
        expect(merge_user.tracked).to eq(true)
      end

      it 'existed pull requests if gh_updated_at is outdated' do
        expect(created_pr.title).to eq('Test')
        expect(created_pr.gh_number).to eq(1)
        expect(created_pr.pr_state).to eq('closed')
        expect(created_pr.gh_created_at).to eq('2017-12-12 09:17:52')
        expect(created_pr.gh_updated_at).to eq('2017-12-14 09:17:52')
        expect(created_pr.gh_closed_at).to eq('2017-12-14 09:17:52')
        expect(created_pr.gh_merged_at).to eq('2017-12-14 09:17:52')
      end

      it 'new reviewers users with correct parameters' do
        gh_user = GithubUser.find_by(gh_id: 4)
        pr_relation = created_pr.pull_request_relations.reviewers
                                .find_by(github_user_id: gh_user.id)
        expect(pr_relation.pr_relation_type).to eq('reviewer')
        expect(gh_user.login).to eq('SecondReviewerUser')
        expect(gh_user.avatar_url).to eq('url_to_avatar')
        expect(gh_user.html_url).to eq('url_to_html')
        expect(gh_user.tracked).to eq(true)
      end
    end
  end
end
