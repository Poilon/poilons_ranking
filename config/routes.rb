Rails.application.routes.draw do
  resources :games do
    resources :tournaments
    resources :participants
  end

  root 'home#show'
end
