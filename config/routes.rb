Rails.application.routes.draw do
  root to: 'visitors#index'

  get 'archive/index'

  resources :disciplines
  resources :semesters
  resources :visits, only: [:create, :destroy, :show, :update]
  resources :relationships, only: [:create, :destroy, :show] do
    member do
      post 'update_proportions'
      get 'total'
    end
  end
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

  devise_for :users
  resources :users do
    collection do
      post 'create_manual'
    end
  end
end
