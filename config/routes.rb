Rails.application.routes.draw do
  get  "sign_in", to: "sessions#new"
  post "sign_in", to: "sessions#create"
  get  "sign_up", to: "registrations#new"
  post "sign_up", to: "registrations#create"
  resources :sessions, only: [:index, :show, :destroy]
  resource  :password, only: [:edit, :update]
  resources :users, excpet: [:show]
  get "users/cancel/:id", to: "users#cancel", as: "users_cancel"
  namespace :identity do
    resource :email,              only: [:edit, :update]
    resource :email_verification, only: [:show, :create]
    resource :password_reset,     only: [:new, :edit, :create, :update]
  end

  root "foundations#index"
  get "foundation/cancel", to: "foundations#cancel"
  resources :foundations, excpet: [:show] do
    get "dashboard", to: "foundations#dashboard"
  end


end
