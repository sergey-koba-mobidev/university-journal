Rails.application.routes.draw do
  root to: 'visitors#index'

  get 'archive/index'
  get 'locales/change', as: 'change_locale'

  resources :disciplines
  resources :semesters
  resources :visits, only: [:create, :destroy, :show, :update] do
    resources :homeworks
    member do
      post 'update_created_at'
    end
  end
  resources :homeworks, only: [:create, :destroy, :show, :update]
  resources :relationships, only: [:create, :destroy, :show] do
    member do
      post 'update_proportions'
      get 'total'
    end
  end
  resources :attends, only: [:create, :update] do
    member do
      post 'update_mark'
      post 'update_title'
    end
  end
  resources :groups do
    member do
      delete 'remove_user'
      post   'add_user'
      get    'search_user'
    end
  end

  devise_for :users, :controllers => {:registrations => "registrations"}
  resources :users do
    collection do
      post 'create_manual'
    end
  end

  namespace :api do
    namespace :v1 do
      post 'sign_in' => 'users#sign_in'
      get  'relationships/current' => 'relationships#current'
    end
  end
end
