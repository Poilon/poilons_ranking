Rails.application.routes.draw do

  resources :tournaments
  get 'generate_from_challonge', controller: 'tournaments'
  root 'home#show'
end
