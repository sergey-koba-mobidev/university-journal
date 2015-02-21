Rails.application.routes.draw do
  resources :relationships, only: [:create, :destroy, :show]
  resources :visits, only: [:create, :destroy, :show]

  resources :groups do
    member do
      delete 'remove_user'
      post   'add_user'
      get    'search_user'
    end
  end

  resources :disciplines

  resources :semesters

  root to: 'visitors#index'
  devise_for :users
  resources :users
end
