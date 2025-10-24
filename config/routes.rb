Rails.application.routes.draw do
  devise_for :users

  authenticate :user do
    resources :accounts, only: [ :index, :show, :new, :create ] do
      member do
        post :switch
      end

      # Risorse dell'account
      namespace :webapp, module: :webapp do
        resources :transactions
        resources :categories
      end

      namespace :console, module: :console do
        get "dashboard", to: "dashboard#index", as: :dashboard
        resources :categories
        resources :transactions
        resources :subscriptions
      end
    end
  end

  root "console/dashboard#index"
end
