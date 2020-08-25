Rails.application.routes.draw do
  default_url_options host: ENV['APPLICATION_HOST']

  get 'home/index', as: :home

  get 'github/callback' => 'github_auth#callback', as: :github_callback
  get 'oauth' => 'github_auth#oauth_request', as: :close_session
  get 'oauth_to_gh' => 'github_auth#authenticate!', as: :github_authenticate
  get 'admin_oauth_to_gh' => 'github_auth#admin_authenticate!', as: :admin_authenticate
  get 'org_oauth_to_gh' => 'github_auth#organization_authenticate!', as: :org_authenticate
  post 'github_events' => 'webhook#receive'

  root 'home#index'

  resources :organizations, param: :name do
    get 'missing' => 'organizations#missing', on: :collection
    get 'settings' => 'organizations#settings', on: :member
    get 'public' => 'organizations#public', on: :member
    resources :pull_requests, only: [:index]
  end

  resources :users, only: [:show], controller: 'github_users'
  get 'me' => 'github_users#me'

  scope path: '/slack', module: 'slack' do
    resources :commands, only: [:create]
    resources :events, only: [:create]
  end

  resources :organizations do
    resources :froggo_teams, only: [:new], controller: 'froggo_teams'
  end

  resources :github_users do
    resources :froggo_teams, only: [:index], controller: 'froggo_teams'
  end

  scope path: '/api', defaults: { format: 'json' } do
    api_version(module: "Api::V1", header: { name: "Accept", value: "version=1" }, default: true) do
      resources :repositories, only: [:update]
      put 'organizations/:id/update_public_enabled' => 'organizations#update_public_enabled'
      put 'organizations/:id/update' => 'organizations#update'
      post 'organizations/:id/sync' => 'organizations#sync'
      get 'organizations/:id/check_sync' => 'organizations#check_sync'
      get 'organizations/:org_id/users/:github_login/score' =>
        'github_users#organization_score'
      get 'organizations/:org_id/users/:github_login/statistics' =>
        'github_users#organization_recommendation_statistics'
      get 'organizations/:org_id/teams/:team_id/users/:github_login/score' =>
        'github_users#team_score'
      get 'teams/:team_id/users/:github_login/recommendations' =>
        'github_users#team_review_recommendations'
      resources :organizations do
        resources :froggo_teams, only: [:index, :show, :create, :destroy, :update], shallow: true do
          member do
            post 'add_member'
            post 'remove_member'
          end
        end
      end
      get 'users/:github_login/pull_requests_information' =>
        'github_users#pull_requests_information'
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
