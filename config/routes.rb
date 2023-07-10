Rails.application.routes.draw do
  root "teams#index"

  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }

  resources :users, :only => [:show]

  resources :teams do
    resources :players do
      resources :contracts
    end
  end

  resources :articles do
    resources :comments
  end

  namespace :admin do
    get 'dashboard', to: 'dashboard#index'
    get '', to: 'dashboard#index'
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
end
