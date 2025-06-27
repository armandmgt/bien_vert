Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  root "plants#index"
  resource :session, only: [ :new, :create, :destroy ]
  resources :users, only: [ :new, :create ]
  resources :passwords, only: [ :new, :create, :edit, :update ], param: :token

  resource :user, only: [ :edit, :update, :destroy ]

  resources :push_subscriptions, only: [ :create, :destroy ] do
    collection { get :vapid_key }
  end

  resources :plants, only: [ :index, :new, :edit, :create, :update, :destroy ] do
    collection { get :watering_quick_selector }
  end
  resources :recognition_requests, only: [ :show, :new, :create, :update ]

  get "privacy", to: "static#privacy"
  get "support", to: "static#support"
end
