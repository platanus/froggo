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
    subject { GithubSession.new(cookies) }
    it 'has the correct session info' do
      expect(subject.session['access_token']).to eq(cookies['access_token'])
      expect(subject.session['client_type']).to eq(cookies['client_type'])
    end

    it 'changes the session info when session changes' do
      expect(subject.set_access_token('another token')).to eq(cookies['access_token'])
      expect(subject.set_session_type('admin')).to eq(cookies['client_type'])
    end

    it { expect(subject.valid?).to eq(true) }
  end
end
