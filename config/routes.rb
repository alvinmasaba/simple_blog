Rails.application.routes.draw do
  root "teams#index"

  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }

  resources :teams do
    resources :players do
      resources :contracts
    end
  end

  resources :articles do
    resources :comments
  end
end
