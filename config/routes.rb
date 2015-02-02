Rails.application.routes.draw do
  devise_for :admins, skip: [:registrations, :passwords]
  resources :games do
    member do
      get :compute
    end
    resources :statistics
    resources :tournaments
    resources :participants
  end

  root 'home#show'
end
