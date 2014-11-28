Rails.application.routes.draw do
  resources :games do
    member do
      get :compute
    end
    resources :tournaments
    resources :participants
  end

  root 'home#show'
end
