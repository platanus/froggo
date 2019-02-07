require 'rails_helper'

describe GithubUserService do
  let!(:gh_user) { create(:github_user) }
  let (:user1) do
    double(login: 'a user',
           id: '3',
           avatar_url: '',
           html_url: '',
           email: '',
           name: '')
  end

  let (:user2) do
    double(login: 'a user',
           id: gh_user.gh_id,
           avatar_url: '',
           html_url: '',
           email: '',
           name: '')
  end


  def build(*_args)
    described_class.new(*_args)
  end

  context 'find_or_create' do
    it 'create a new GithubUser in BD' do
      expect { build.find_or_create(user1) }
        .to change { GithubUser.all.count }.by(1)
    end

    it 'find an existing user in BD' do
      find = build.find_or_create(user2)
      expect(find).to eq(gh_user)
    end
  end

  context 'fetch_teams_for_user' do
    let (:organization_1) do
      organization = double('organization_1')
      allow(organization).to receive(:login) { 'organization_1_login' }
      organization
    end

    let (:organization_2) do
      organization = double('organization_2')
      allow(organization).to receive(:login) { 'organization_2_login' }
      organization
    end

    let (:organizations) do
      [ organization_1, organization_2 ]
    end

    let (:team_1_data) do
      { name: 'team_1', id: 'team_1_id' }
    end

    let (:team_1) do
      team = double('team_1', **team_1_data)
      allow(team).to receive(:to_attrs) { team_1_data }
      team
    end

    let (:team_2_data) do
      { name: 'team_2', id: 'team_2_id' }
    end

    let (:team_2) do
      team = double('team_2', **team_2_data)
      allow(team).to receive(:to_attrs) { team_2_data }
      team
    end

    let (:teams) do
      [ team_1, team_2 ]
    end

    let (:octokit_client_with_teams) do
      client = double('octokit-client')
      allow(client).to receive(:organizations) { organizations }
      allow(client).to receive(:organization_teams) { teams }
      client
    end

    let (:octokit_client_with_no_orgs) do
      client = double('octokit-client')
      allow(client).to receive(:organizations) { [] }
      client
    end

    it 'returns empty list when no organizations found' do
      teams = build.fetch_teams_for_user('login', octokit_client_with_no_orgs)
      expect(teams).to be_empty
    end

    it 'returns teams' do
      teams = build.fetch_teams_for_user('login', octokit_client_with_teams)
      expect(teams[0]).to equal(team_1_data)
      expect(teams[1]).to equal(team_2_data)
    end
  end
end
