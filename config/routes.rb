Rails.application.routes.draw do
  resources :games
  get '/rankings', to: 'pages#rankings'
  get '/feed', to: 'pages#feed'
  get '/faq', to: 'pages#faq'
  get '/news', to: 'pages#news'
  # get '/api/games', to: 'api#games'
  root 'pages#rankings'

  devise_for :users

  namespace :api do
    namespace :v1, defaults: { format: :json } do
      resources :games
      resources :players
    end
  end
end
