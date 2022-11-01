Rails.application.routes.draw do
  root "teams#index"
  get 'auth/:discord/callback', to: 'sessions#create'
  get '/login', to: 'sessions#new'

  resources :teams do
    resources :players do
      resources :contracts
    end
  end

  resources :articles do
    resources :comments
  end
end
