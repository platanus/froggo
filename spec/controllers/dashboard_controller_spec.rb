require 'rails_helper'

RSpec.describe DashboardController, type: :controller do
  describe 'GET #index' do
    let (:client) { double }
    subject { get :index, session: { 'access_token' => 3 } }
    let (:gh_organizations) { [{ login: 'gh_orga', id: 10, role: 'member' }] }

    before do
      allow(Octokit::Client).to receive(:new).and_return(client)
    end

    context 'when user exists with organizations' do
      before do
        allow(client).to receive(:user).and_return('login': '')
        expect_any_instance_of(OctokitClient).to receive(:fetch_organization_memberships)
          .and_return(gh_organizations)
      end

      it 'returns should have found status code' do
        expect(subject).to have_http_status(302)
      end

      it 'redirects to first organization dashboard' do
        expect(subject).to redirect_to('/dashboard/gh_orga')
      end

      it 'does not render a different template' do
        expect(subject).to_not render_template('admin')
      end

      context 'with gh_org params with membership' do
        subject do
          get :index, session: { 'access_token' => 3 },
                      params: { gh_org: gh_organizations.first[:login] }
        end

        it 'does not redirect to first organization dashboard' do
          expect(subject).not_to redirect_to('/dashboard/gh_orga')
        end

        it { expect(subject).to render_template('index') }
      end

      context 'with gh_org params without membership' do
        subject do
          get :index, session: { 'access_token' => 3 },
                      params: { gh_org: 'new_organization' }
        end

        it 'redirects to first organization dashboard' do
          expect(subject).to redirect_to('/dashboard/gh_orga')
        end

        it 'renders the index template' do
          expect(subject).not_to render_template('index')
        end
      end
    end

    context 'when user exists without organizations' do
      let!(:empty_organizations) { {} }
      before do
        expect_any_instance_of(OctokitClient).to receive(:fetch_organization_memberships)
          .and_return(empty_organizations)
      end
      it { expect(subject).to redirect_to('/dashboard/missing_organizations') }
    end
  end
end
