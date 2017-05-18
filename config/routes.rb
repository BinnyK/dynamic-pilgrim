Rails.application.routes.draw do
  resources :games
  get '/rankings', to: 'pages#rankings'
  get '/elo', to: 'pages#elo'
  get '/feed', to: 'pages#feed'
  get '/faq', to: 'pages#faq'
  get '/news', to: 'pages#news'
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
