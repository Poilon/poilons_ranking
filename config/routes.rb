Rails.application.routes.draw do
  resources :tournaments

  root 'home#show'
end
