Rails.application.routes.draw do
  root "teams#index"

  resources :teams do
    resources :players do
      resources :contracts
    end
  end

  resources :articles do
    resources :comments
  end
end
