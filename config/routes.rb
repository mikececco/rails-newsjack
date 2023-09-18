Rails.application.routes.draw do
  root to: "pages#home"
  get 'blog', to: 'pages#blog'
  get 'early_access', to: 'pages#early_access'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  mount ActiveAnalytics::Engine, at: "analytics"

  resources :waiting_users, only: [:create]
  resources :trial_click_users, only: [:create]
  resources :search_preferences, only: [:new, :create] do
    get 'results', on: :collection
  end
end
