require 'rails_helper'

RSpec.describe GithubSession, type: :class do
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

  def create_org_response(id, org, avatar_url, role)
    double(
      organization: double(id: id, login: org, avatar_url: avatar_url),
      role: role
    )
  end

  before do
    expect(BuildOctokitClient).to receive(:for)
      .with(token: 'a token').and_return(client)
    expect(client).to receive(:user)
      .and_return(user_response)
    expect(client).to receive(:organization_memberships)
      .and_return(org_response)
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
end
