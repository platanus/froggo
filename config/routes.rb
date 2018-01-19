Rails.application.routes.draw do
  default_url_options host: ENV['APPLICATION_HOST']

  get 'github/callback' => 'github_auth#callback', as: :github_callback
  get 'oauth' => 'github_auth#oauth_request'
  get 'oauth_to_gh' => 'github_auth#authenticate!'
  get 'webhook/index'
  get 'dashboard/missing_organizations' => 'dashboard#missing_organizations',
      as: :dashboard_missing_organizations
  get 'dashboard/:gh_org' => 'dashboard#index', as: :dashboard
  get 'dashboard' => 'dashboard#index'
  get 'dashboard/:gh_org/settings' => 'dashboard#settings', as: :config
  post 'dashboard' => 'dashboard#create', as: :create_dashboard
  post 'github_events' => 'webhook#receive'

  root to: redirect('dashboard')

  scope path: '/api' do
    api_version(module: "Api::V1", path: { value: "v1" }, defaults: { format: 'json' }) do
    end
  end

  devise_config = ActiveAdmin::Devise.config
  devise_config[:controllers][:omniauth_callbacks] = 'admin_users/omniauth_callbacks'
  devise_for :admin_users, devise_config
  ActiveAdmin.routes(self)
  devise_for :users
  mount Sidekiq::Web => '/queue'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
