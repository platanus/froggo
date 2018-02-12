require 'rails_helper'

RSpec.describe GithubAuthController, type: :controller do
  describe 'GET #callback' do
    let(:github_return_code) { 'github_code' }
    subject { get :callback, params: { client_type: :member, code: github_return_code } }
    let(:token_result) { { access_token: 'token' } }
    before do
      expect(Octokit).to receive(:exchange_code_for_token)
        .with(github_return_code, ENV['GH_AUTH_ID'], ENV['GH_AUTH_SECRET'])
        .and_return(token_result)
    end

    it 'sets session values correctly' do
      subject
      expect(session[:access_token]).to eq(token_result[:access_token])
      expect(session[:client_type]).to eq('member')
    end

    it { expect(subject).to redirect_to(organizations_path) }

    context 'from dashboard settings of organization' do
      let(:gh_org) { 'test_org' }
      subject do
        get :callback, params: { client_type: :member,
                                 code: github_return_code,
                                 callback_action: 'settings',
                                 gh_org: gh_org }
      end

      it { expect(subject).to redirect_to(settings_organization_path(name: gh_org)) }
    end
  end
end
