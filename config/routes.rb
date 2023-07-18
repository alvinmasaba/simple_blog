Rails.application.routes.draw do
  root "teams#index"

  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }

  resources :users, :only => [:show]

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
  end

  resources :tweets, only: [:index]

  resources :players, only: [:index, :show]

  get 'trade_machine', action: :show, controller: 'trade_machine'
end
