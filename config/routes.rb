Codestats::Application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: 'omniauth_callbacks' }
  root to: 'organizations#index'

  resources :organizations do
    member do
      get :link_to_github
      post :unlink_github
    end
    resources :projects, only: [:new, :create, :show, :index] do
      resources :branches, only: [:index, :show]
    end
  end

  # API Endpoints
  api_version(module:  'api/v1', path: { value: 'api/v1' }, defaults: { format: :json }) do
    resources :metrics, only: [:create]
  end

  require 'sidekiq/web'
  mount Sidekiq::Web, at: 'sidekiq'
  mount PgHero::Engine, at: 'pghero'
end
