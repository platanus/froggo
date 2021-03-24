require 'rails_helper'

RSpec.describe GithubAuthController, type: :controller do
  describe 'GET #callback' do
    let(:github_return_code) { 'github_code' }
    let(:token_result) { { access_token: 'token' } }
    let(:path) { nil }
    let(:gh_organizations) { [] }
    let(:gh_user_id) { 123 }
    let(:gh_user) { create(:github_user, gh_id: gh_user_id) }
    let!(:github_session) do
      instance_double(
        'GithubSession',
        set_session: [],
        froggo_path: path,
        token: 'token',
        user: gh_user
      )
    end

    before do
      allow(Octokit).to receive(:exchange_code_for_token)
        .with(github_return_code, ENV['GH_AUTH_ID'], ENV['GH_AUTH_SECRET'])
        .and_return(token_result)
      allow(controller).to receive(:github_session).and_return(github_session)
      allow(github_session).to receive(:organizations).and_return(gh_organizations)
    end

    context 'when user has more organizations in Github that in Froggo' do
      let(:first_organization) { create(:organization) }
      let(:second_organization) { create(:organization) }
      let(:expected_organization_memberships) { 2 }
      let(:gh_organizations) do
        [{ id: first_organization.gh_id }, { id: second_organization.gh_id }, { id: 234 }]
      end

      before do
        get :callback, params: { client_type: :member, code: github_return_code }
      end

      it 'creates organization membership in first_organization and second_organization' do
        expect(
          OrganizationMembership.find_by(organization: first_organization, github_user: gh_user)
        ).not_to be_nil
        expect(
          OrganizationMembership.find_by(organization: first_organization, github_user: gh_user)
        ).not_to be_nil
      end

      it 'does not create organization membership in third organization' do
        expect(
          OrganizationMembership.where(github_user: gh_user).count
        ).to be(expected_organization_memberships)
      end
    end

    context 'from home without last path in github session' do
      before do
        get :callback, params: { client_type: :member, code: github_return_code }
      end

      it { expect(response).to redirect_to(user_path(github_session.user)) }
    end

    context 'from home with last path in github session' do
      let(:path) { organization_path(name: 'org') }

      before do
        get :callback, params: { client_type: :member, code: github_return_code }
      end

      it {
        expect(response).to redirect_to(user_path(github_session.user))
      }
    end

    context 'from dashboard settings of organization' do
      let(:gh_org) { 'test_org' }
      before do
        get :callback, params: { client_type: :member,
                                 code: github_return_code,
                                 callback_action: 'settings',
                                 gh_org: gh_org }
      end

      it { expect(response).to redirect_to(settings_organization_path(name: gh_org)) }
    end

    context 'configure organizations' do
      context 'from home' do
        before do
          get :callback, params: { client_type: :member,
                                   code: github_return_code,
                                   callback_action: 'add_organization' }
        end

        it { expect(response).to redirect_to(user_path(github_session.user)) }
      end

      context 'when grant is not revoked' do
        before do
          allow(subject).to receive(:delete_application_grant).and_return(false)
        end
        it 'does not redirect to github auth' do
          subject.organization_authenticate!
          expect { expect(GetGithubAuthUrl).to_not receive(:for) }
        end
      end
    end
  end
end
