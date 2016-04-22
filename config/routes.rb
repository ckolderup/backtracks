require 'resque/server'

Rails.application.routes.draw do
  resque_web_constraint = lambda do |request|
    current_user = User.where(id: request.cookie_jar.signed[:user_id] || 0).first
    current_user.present? && current_user.respond_to?(:admin?) && current_user.admin?
  end

  constraints resque_web_constraint do
    mount ResqueWeb::Engine => "/resque"
  end

  get "log_out" => "sessions#destroy", as: "log_out"
  get "log_in" => "sessions#new", as: "log_in"
  get "sign_up" => "users#new", as: "sign_up"
  post "sign_up" => "users#create", as: "account_create"

  get "account" => "users#edit", as: "account"
  patch "account" => "users#update", as: "account_update"

  get "latest" => "home#latest", as: 'latest_pending_redirect'
  get "latest/:slug" => "home#latest", as: 'latest'

  get '/recover_password' => 'password_recoveries#new', as: 'recover_password'
  post '/recover_password' => 'password_recoveries#create', as: 'create_password_recovery'
  get '/reset_password' => 'password_recoveries#lookup', as: 'lookup_password_recovery'
  patch '/reset_password' => 'password_recoveries#reset', as: 'reset_password'

  root to: "home#index"

  resources :sessions

  get 'not_found' => 'errors#not_found', as: 'not_found'
  get "*any", via: :all, to: "errors#not_found"
end
