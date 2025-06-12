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

  resources :quizzes, only: [ :index ] do
    collection do
      get "results"
      post "record_answer"
    end
  end

  resources :dashboards, only: [:index]
  resources :homepage, only: [:index]
  resources :courses, except: [:index, :show] do
    member do
      get :roster, defaults: { format: :pdf }
    end
  end
  resources :quizzes, only: [:index]

  # Adding routes for custom error pages
  match "/404", to: "errors#show", code: 404, via: :all
  match "/500", to: "errors#show", code: 500, via: :all
  match "/400", to: "errors#show", code: 400, via: :all
end
