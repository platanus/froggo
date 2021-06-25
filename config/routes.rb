Rails.application.routes.draw do
  scope path: '/api' do
    api_version(module: 'Api::V1', path: { value: 'v1' }, defaults: { format: 'json' }) do
      resources :repositories, only: [:update]
      put 'organizations/:id/update' => 'organizations#update'
      post 'organizations/:id/sync' => 'organizations#sync'
      get 'organizations/:id/check_sync' => 'organizations#check_sync'
      get 'organizations/:org_id/users/:github_login/statistics' =>
        'github_users#organization_recommendation_statistics'
      get 'teams/:team_id/users/:github_login/recommendations' =>
        'github_users#team_review_recommendations'
      resources :organizations, only: [:index] do
        resources :froggo_teams, only: [:index, :show, :create, :destroy, :update], shallow: true
      end
      resources :pull_requests do
        resources :likes, only: [:create, :destroy]
      end
      resources :github_users, only: [] do
        get '/open_prs' => :open_prs, on: :collection
      end
      patch 'github_users/:id' => 'github_users#update'
      get 'users/:github_login/pull_requests_information' =>
        'github_users#pull_requests_information'
      post 'pull_request_reviewer/add' => 'pull_request_reviewers#add_reviewer'
      get 'github_users/:id/preferences' => 'preferences#show'
      patch 'github_users/:id/preferences' => 'preferences#update'
    end
  end
  mount Rswag::Api::Engine => '/api-docs'
  mount Rswag::Ui::Engine => '/api-docs'
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
    resources :pull_requests, only: [:index, :show]
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

  resources :froggo_teams, only: [:show], controller: 'froggo_teams'
  get 'froggo_teams/:id/edit' => 'froggo_teams#edit'

  devise_config = ActiveAdmin::Devise.config
  devise_config[:controllers][:omniauth_callbacks] = 'admin_users/omniauth_callbacks'
  devise_for :admin_users, devise_config
  ActiveAdmin.routes(self)
  devise_for :users
  mount Sidekiq::Web => '/queue'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
