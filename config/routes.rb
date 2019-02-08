Rails.application.routes.draw do
  root to: 'visitors#index'

  get 'archive/index'
  get 'locales/change', as: 'change_locale'

  resources :disciplines
  resources :semesters
  resources :visits, only: [:create, :destroy, :show, :update] do
    resources :homeworks
    member do
      get 'result'
      post 'update_created_at'
    end
  end
  resources :homeworks, only: [:create, :destroy, :show, :update]
  resources :relationships, only: [:create, :destroy, :show] do
    member do
      post 'update_proportions'
      get 'total'
    end
    resources :discipline_modules, only: [:index]
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
  resources :student_modules, only: [:show, :destroy] do
    member do
      post 'update_answer_result'
      post 'check_answers'
      get  'finish_check'
      get  'copy_result'
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
      get  'relationships/:relationship_id/modules' => 'visits#get_modules'
      get  'relationships/:relationship_id/modules/:id' => 'student_modules#show'
      post 'relationships/:relationship_id/modules/:id/questions/:question_id/answer' => 'student_modules#answer'
      post 'relationships/:relationship_id/modules/:id/finish' => 'student_modules#finish'

      get  'disciplines/:discipline_id/modules' => 'discipline_modules#index'
      post 'disciplines/:discipline_id/modules' => 'discipline_modules#create'
      get 'disciplines/:discipline_id/modules/:id' => 'discipline_modules#show'
      post 'disciplines/:discipline_id/modules/:id' => 'discipline_modules#update'
      delete 'disciplines/:discipline_id/modules/:id' => 'discipline_modules#delete'

      get  'modules/:discipline_module_id/question_groups' => 'question_groups#index'
      post 'modules/:discipline_module_id/question_groups' => 'question_groups#create'
      get  'modules/:discipline_module_id/question_groups/:id' => 'question_groups#show'
      post 'modules/:discipline_module_id/question_groups/:id' => 'question_groups#update'
      delete 'modules/:discipline_module_id/question_groups/:id' => 'question_groups#delete'
      
      get  'question_groups/:question_group_id/questions' => 'questions#index'
      post 'question_groups/:question_group_id/questions' => 'questions#create'
      post 'question_groups/:question_group_id/questions/:id' => 'questions#update'
      delete 'question_groups/:question_group_id/questions/:id' => 'questions#delete'

      get  'disciplines' => 'disciplines#index'
    end
  end
end
