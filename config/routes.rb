Rails.application.routes.draw do
  resources :games
<<<<<<< HEAD
  get 'pages/rankings'
  get 'pages/ELO'
  get 'pages/feed'
  get 'pages/faq'
  get 'pages/news'
=======
  get '/rankings', to: 'pages#rankings'
  get '/feed', to: 'pages#feed'
  get '/faq', to: 'pages#faq'
  get '/news', to: 'pages#news'
>>>>>>> upstream/master
  root 'pages#rankings'

  devise_for :users
  resources :users, only: [:show]

  namespace :api do
    namespace :v1, defaults: { format: :json } do
      resources :games
      resources :players
    end
  end
end
