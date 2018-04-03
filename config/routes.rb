Rails.application.routes.draw do
  default_url_options host: ENV['APPLICATION_HOST']

  get 'home/index', as: :home

  get 'github/callback' => 'github_auth#callback', as: :github_callback
  get 'oauth' => 'github_auth#oauth_request', as: :close_session
  get 'oauth_to_gh' => 'github_auth#authenticate!', as: :github_authenticate
  get 'admin_oauth_to_gh' => 'github_auth#admin_authenticate!', as: :admin_authenticate
  get 'webhook/index'
  post 'github_events' => 'webhook#receive'

  root 'home#index'

  resources :organizations, param: :name do
    get 'missing' => 'organizations#missing', on: :collection
    get 'settings' => 'organizations#settings', on: :member
  end

  scope path: '/api', defaults: { format: 'json' } do
    api_version(module: "Api::V1", header: { name: "Accept", value: "version=1" }, default: true) do
      resources :repositories, only: [:update]
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
