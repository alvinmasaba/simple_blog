Rails.application.routes.draw do
  root "teams#index"

  resources :teams

  resources :articles do
    resources :comments
  end
end
