Rails.application.routes.draw do
  devise_for :users
  root "teams#index"

  get 'auth/discord/callback', to: 'omniauth_callbacks#discord'

  resources :teams do
    resources :players do
      resources :contracts
    end
  end

  resources :articles do
    resources :comments
  end
end
