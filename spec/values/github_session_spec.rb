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

  let(:user) { create(:github_user) }

  subject { GithubSession.new(cookies) }

  before do
    allow(BuildOctokitClient).to receive(:for)
      .with(token: 'a token').and_return(client)
    allow_any_instance_of(GithubUserService).to\
      receive(:find_or_create).with(user_response).and_return(user)
  end

  context 'when initialized with correct session' do
    it 'has the correct info' do
      expect(subject.session['access_token']).to eq(cookies['access_token'])
      expect(subject.session['client_type']).to eq(cookies['client_type'])
      expect(subject.user).to eq(user)
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
      let(:user) { create(:github_user) }
      before { allow(user).to receive(:organizations).and_return([]) }
      it { expect(subject.fetch_teams_for_user(user)).to be_empty }
    end

    context 'when organizations have teams' do
      let(:team1) { double(id: 1) }

      let(:team2) { double(id: 2) }

      let(:team3) { double(id: 3) }

      let(:team4) { double(id: 4) }

      let(:teams) do
        [team1, team2, team3, team4]
      end

      let(:user) { create(:github_user) }

      let(:organizations) do
        [create(:organization), create(:organization)]
      end

      let(:org_0_teams) { [teams[0], teams[1]] }
      let(:org_1_teams) { [teams[2], teams[3]] }

      before do
        allow(team1).to \
          receive(:[]).and_return(team1.id)
        allow(team2).to \
          receive(:[]).and_return(team2.id)
        allow(team3).to \
          receive(:[]).and_return(team3.id)
        allow(team4).to \
          receive(:[]).and_return(team4.id)
        allow(user).to \
          receive(:organizations).and_return(organizations)
        allow(client).to \
          receive(:team_member?).and_return(true)
        allow(subject).to \
          receive(:get_teams).and_return(org_0_teams, org_1_teams)
        allow(client).to \
          receive(:team_member?).and_return(true)
      end

      it 'returns teams' do
        expect(subject.fetch_teams_for_user(user))
          .to eq([*org_0_teams, *org_1_teams])
      end
    end
  end
end
