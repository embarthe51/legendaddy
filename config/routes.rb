Rails.application.routes.draw do
  devise_for :users
  root to: "pages#home"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  resources :activities, only: [:index, :show] do
    resources :bookings, only: [:new, :create]
  end
  resources :reviews, only: [:index]
  resources :bookings, only: [:index, :show, :destroy]
  resources :availabilities, only: [:index, :new, :create]
  post '/search_activities', to: 'activities#search', as: :search_activities
end
