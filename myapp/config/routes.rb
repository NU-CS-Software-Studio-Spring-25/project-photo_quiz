Rails.application.routes.draw do
  # Devise
  devise_for :users, sign_out_via: %i[delete get]

  # Single root
  root to: "homepage#index"

  # resources
  resources :students do
  member do
      get :confirm_destroy
      get :thank_you
    end
  end
  
  resources :courses, except: [:index, :show]
  resources :quizzes, only: [:index]

  # Adding routes for custom error pages
  match '/404', to: 'errors#show', code: 404, via: :all
  match '/500', to: 'errors#show', code: 500, via: :all
  match '/400', to: 'errors#show', code: 400, via: :all
end
  #get "quizzes", to: "quizzes#index"
  # root :to => redirect('/students')

  # Default Stuffs => Might need to be deleted later
  # # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # # Can be used by load balancers and uptime monitors to verify that the app is live.
  # get "up" => "rails/health#show", as: :rails_health_check

  # # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # # Defines the root path route ("/")
  # # root "posts#index"
