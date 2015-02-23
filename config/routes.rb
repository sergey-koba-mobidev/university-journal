Rails.application.routes.draw do
  get 'attends/create'

  get 'attends/update'

  resources :relationships, only: [:create, :destroy, :show]
  resources :visits, only: [:create, :destroy, :show, :update]
  resources :attends, only: [:create, :update] do
    member do
      post 'update_mark'
    end
  end

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
