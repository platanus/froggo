require 'rails_helper'

RSpec.describe GithubSession, type: :class do
  def create_org_response(id, org, avatar_url, role)
    double(
      organization: double(id: id, login: org, avatar_url: avatar_url),
      role: role
    )
  end

  let(:cookies) do
    ActionDispatch::Cookies::CookieJar.build({}, 'access_token': 'a token', 'client_type': 'member')
  end

  let(:org_response) do
    [create_org_response('123', 'platanus', 'platanus_avatar', 'member'),
     create_org_response('456', 'my_org', 'my_org_avatar', 'admin')]
  end

  let(:user_response) { JSON.parse({ 'login': 'user login', 'avatar_url': 'avatar' }.to_json) }

  let!(:client) { double(user: user_response, organization_memberships: org_response) }
  subject { GithubSession.new(cookies) }

  before do
    allow(BuildOctokitClient).to receive(:for)
      .with(token: 'a token').and_return(client)
  end

  context 'when initialized with correct session' do
    it 'has the correct info' do
      expect(subject.session['access_token']).to eq(cookies['access_token'])
      expect(subject.session['client_type']).to eq(cookies['client_type'])
      expect(subject.name).to eq(client.user["login"])
      expect(subject.avatar_url).to eq(client.user["avatar_url"])
      expect(subject.organizations).to eq(
        [
          {
            id: org_response[0].organization.id,
            login: org_response[0].organization.login,
            role: org_response[0].role,
            avatar_url: org_response[0].organization.avatar_url
          },
          {
            id: org_response[1].organization.id,
            login: org_response[1].organization.login,
            role: org_response[1].role,
            avatar_url: org_response[1].organization.avatar_url
          }
        ]
      )
    end

    it { expect(subject.valid?).to eq(true) }
  end

  context 'when session info is set' do
    before do
      subject.set_session('another token', 'admin')
    end

    it 'has the correct session info' do
      expect(subject.session['access_token']).to eq(cookies['access_token'])
      expect(subject.session['client_type']).to eq(cookies['client_type'])
      expect(subject.session['access_token']).to eq('another token')
      expect(subject.session['client_type']).to eq('admin')
    end
  end

  context 'when cleaning session' do
    before do
      subject.clean_session
    end

    it 'erases cookies' do
      expect(cookies['access_token']).to eq("")
      expect(cookies['client_type']).to eq("")
    end
  end

  describe 'fetch_teams_for_user' do
    context 'when no organizations found' do
      before { allow(client).to receive(:organizations).and_return([]) }
      it { expect(subject.fetch_teams_for_user('login')).to be_empty }
    end

    context 'when organizations have teams' do
      let(:teams) do
        create_team = ->(id, name) { { id: id, name: name, slug: name } }
        (0...4).map { |id| create_team.call(id, "team-#{id}") }
      end

      let(:github_organizations) do
        [{ id: 0 }, { id: 1 }]
      end

      let(:org_0_teams) { [teams[0], teams[1]] }
      let(:org_1_teams) { [teams[2], teams[3]] }

      before do
        allow(Organization).to receive(:find_by!).and_return(create(:organization))
        allow(client).to \
          receive(:organizations).and_return(github_organizations)
        allow(subject).to \
          receive(:get_teams).and_return(org_0_teams, org_1_teams)
      end

      it 'returns teams' do
        expect(subject.fetch_teams_for_user('some_login'))
          .to eq([*org_0_teams, *org_1_teams])
      end
    end
  end
end
