require 'rails_helper'

describe PullRequestReviewService do
  def build(*_args)
    described_class.new(*_args)
  end

  let!(:pull_request) { create(:pull_request) }

  context 'get submitted call' do
    let!(:request) do
      {
        review: {
          user: {
            id: 1,
            login: 'UserReviewer',
            avatar_url: 'url_to_avatar',
            html_url: 'url_to_html'
          }
        },
        pull_request: { id: 1 }
      }
    end
    let!(:review_service) { PullRequestReviewService.new(payload: request) }

    before do
      review_service.submit_review
    end

    it 'create new github users if missing' do
      gh_user = GithubUser.first
      expect(gh_user.gh_id).to eq(request[:review][:user][:id])
      expect(gh_user.login).to eq(request[:review][:user][:login])
      expect(gh_user.avatar_url).to eq(request[:review][:user][:avatar_url])
      expect(gh_user.html_url).to eq(request[:review][:user][:html_url])
      expect(gh_user.tracked).to eq(true)
    end

    it 'create pull request relation correctly' do
      pr_relation = PullRequestRelation.first
      expect(pr_relation.pr_relation_type).to eq('reviewer')
      expect(pr_relation.github_user_id).to eq(GithubUser.first.id)
    end
  end
end
