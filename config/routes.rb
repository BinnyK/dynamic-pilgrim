Rails.application.routes.draw do
  resources :games
  get '/rankings', to: 'pages#rankings'
  get '/feed', to: 'pages#feed'
  get '/faq', to: 'pages#faq'
  get '/news', to: 'pages#news'
  root 'pages#rankings'

  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html


end
