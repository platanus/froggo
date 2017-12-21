require 'rails_helper'

describe PullRequestService do
  let(:payload) do
    {
      action: 'opened',
      pull_request: {
        id: 34778301,
        title: 'Update the README with new information',
        number: 1,
        state: 'open',
        html_url: 'https://github.com/baxterthehacker/public-repo/pull/1',
        created_at: "2015-05-05T23:40:27Z",
        updated_at: "2015-05-05T23:40:27Z",
        closed_at: nil,
        merged_at: nil,
        user: {
          id: 1,
          login: 'bunzli',
          avatar_url: 'https://avatars2.githubusercontent.com/u/741483?v=4',
          html_url: 'https://github.com/bunzli'
        }
      },
      repository: {
        id: 1
      }
    }
  end

  let(:merger) do
    {
      id: 2,
      login: 'ldlsegovia',
      avatar_url: 'https://avatars2.githubusercontent.com/u/3026413?s=400&v=4',
      html_url: 'https://github.com/ldlsegovia'
    }
  end

  def build(payload)
    described_class.new(payload: payload)
  end

  before do
    create(:repository, id: 1)
  end

  it "calls create_pull_request" do
    expect_any_instance_of(described_class).to(
      receive(:create_pull_request)
    )
    build(payload).process
  end

  it "creates pull_request" do
    build(payload).process

    expect(
      PullRequest.where(
        gh_id: 34778301,
        title: 'Update the README with new information',
        gh_number: 1,
        pr_state: 'open',
        html_url: 'https://github.com/baxterthehacker/public-repo/pull/1'
      )
    ).to exist
  end

  it "creates owner" do
    build(payload).process

    expect(
      GithubUser.where(
        gh_id: 1,
        login: 'bunzli',
        avatar_url: 'https://avatars2.githubusercontent.com/u/741483?v=4',
        html_url: 'https://github.com/bunzli'
      )
    ).to exist
  end

  it "calls update_pull_request" do
    expect_any_instance_of(described_class).to(
      receive(:update_pull_request)
    )
    payload[:action] = 'edited'
    build(payload).process
  end

  context "create merge" do
    it "creates merge data and update pull_request" do
      payload[:action] = 'closed'
      payload[:pull_request][:state] = 'closed'
      payload[:pull_request][:merged_by] = merger
      build(payload).process

      pull_request = PullRequest.find_by(gh_id: 34778301)

      expect(pull_request.pr_state).to eq('closed')

      expect(
        GithubUser.where(
          gh_id: 2,
          login: 'ldlsegovia',
          avatar_url: 'https://avatars2.githubusercontent.com/u/3026413?s=400&v=4',
          html_url: 'https://github.com/ldlsegovia'
        )
      ).to exist
    end

    it "assigns the relationship" do
      payload[:action] = 'closed'
      payload[:pull_request][:state] = 'closed'
      payload[:pull_request][:merged_by] = merger
      build(payload).process

      pull_request = PullRequest.find_by(gh_id: 34778301)
      merger = GithubUser.find_by(gh_id: 2)

      expect(pull_request.has_merge_users?(merger.id)).to be true
    end
  end
end
