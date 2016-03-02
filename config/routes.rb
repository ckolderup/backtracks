Rails.application.routes.draw do

  get "log_out" => "sessions#destroy", as: "log_out"
  get "log_in" => "sessions#new", as: "log_in"
  get "sign_up" => "users#new", as: "sign_up"
  post "sign_up" => "users#create", as: "account_create"

  get "account" => "users#edit", as: "account"
  patch "account" => "users#update", as: "account_update"

  get "latest" => "home#latest", as: 'latest_pending_redirect'
  get "latest/:slug" => "home#latest", as: 'latest'

  root to: "home#index"

  resources :sessions

  get 'not_found' => 'errors#not_found', as: 'not_found'
  get "*any", via: :all, to: "errors#not_found"
end
