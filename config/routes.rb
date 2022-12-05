Rails.application.routes.draw do
  resources :convos, only: [:index] do
    resources :messages, only: [:index, :new, :create]
  end

  devise_for :users
  root to: "pages#home"

  resources :activities, only: [:index, :show] do
    resources :bookings, only: [:new, :create]
    resources :reviews, only: [:index, :new, :create]
  end

  resources :bookings, only: [:index, :show, :destroy]
  resources :availabilities, only: [:index, :new, :create] do
    resources :activities, only: [:index, :show] do
      resources :bookings, only: [:new, :create]
      resources :reviews, only: [:index]
    end
  end
  post '/search_activities', to: 'activities#search', as: :search_activities
  post '/availabilities/:availability_id/search_activities', to: 'activities#search', as: :search_availability_activities
end
