Rails.application.routes.draw do
  root "teams#index"

  get 'teams/table', to: 'teams#table'

  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }

  resources :users

  get 'players/search', to: 'players#search', as: 'search_players'

  resources :teams do
    resources :players do
      resources :contracts
    end
  end

  resources :articles do
    resources :comments
  end

  namespace :admin do
    get 'dashboard', to: 'dashboard#react'
    get '', to: 'dashboard#react'
    resources :players
    resources :teams do
      resources :players do
        resources :contracts
      end
    end

    resources :articles
    resources :cap_figures
    resources :articles
    resources :users
    resources :team_requests, only: [:index] do
      patch 'approve', on: :member
    end
  end

  resources :tweets, only: [:index]

  resources :players, only: [:index, :show]

  get 'teams/table', action: :table, controller: 'teams'
  get 'trade_machine', action: :show, controller: 'trade_machine'
  post 'evaluate_trade', to: 'trade_machine#evaluate_trade', as: 'evaluate_trade'
  get 'trade_machine/load_assets', to: 'trade_machine#load_assets', as: 'load_assets'
end
