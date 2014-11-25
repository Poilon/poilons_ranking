Rails.application.routes.draw do
  resources :games do
    resources :tournaments
    member do
      get 'ranking'
    end
  end

  root 'home#show'
end
