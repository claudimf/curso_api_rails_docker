require 'sidekiq/web'

Rails.application.routes.draw do
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  # Letter opener - view emails sent by the backend
  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: "/letter_opener"
    LetterOpenerWeb::Engine.routes.append do
      post 'clear'                 => 'letters#clear'
      post ':id'                   => 'letters#destroy'
    end
  end

  namespace :api do
    namespace :v1 do
      resources :contacts
    end
  end
end
