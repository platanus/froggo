require 'rails_helper'

describe GetGithubAuthUrl do
  def perform(*_args)
    described_class.for(*_args)
  end

  let(:member_scope) { 'read:user,read:org' }
  let(:admin_scope) { 'user,repo,admin:org,admin:repo_hook,admin:org_hook' }
  let(:env_gh_auth_id) { ENV['GH_AUTH_ID'] }
  let(:callback_action) { :action }

  context 'with callback action' do
    let(:client_type) { :member }

    before do
      expect_any_instance_of(Octokit::Client).to receive(:authorize_url)
        .with(
          env_gh_auth_id,
          scope: member_scope,
          redirect_uri: Rails.application.routes.url_helpers.github_callback_url(
            callback_action: callback_action, client_type: client_type
          )
        )
        .and_return('')
    end

    it 'creates  redirect uri with callback action query param' do
      perform(callback_action: callback_action, client_type: client_type)
    end
  end

  context 'with client type admin' do
    let(:client_type) { :admin }

    it 'gets oauth url with admin scope' do
      expect_any_instance_of(Octokit::Client).to receive(:authorize_url)
        .with(
          env_gh_auth_id,
          scope: admin_scope,
          redirect_uri: Rails.application.routes.url_helpers.github_callback_url(
            callback_action: callback_action, client_type: client_type
          )
        )
        .and_return('')

      perform(callback_action: callback_action, client_type: client_type)
    end
  end

  context 'with client type member' do
    let(:client_type) { :member }
    it 'gets oauth url with member scope' do
      expect_any_instance_of(Octokit::Client).to receive(:authorize_url)
        .with(
          env_gh_auth_id,
          scope: member_scope,
          redirect_uri: Rails.application.routes.url_helpers.github_callback_url(
            callback_action: callback_action, client_type: client_type
          )
        )
        .and_return('')

      perform(callback_action: callback_action, client_type: client_type)
    end
  end
end
