Rails.application.routes.draw do

  devise_for :users
  resources :teams
  resources :user_profile

  resources :projects
  resources :sprints, except: [:index]
  resources :activities, except: [:index]
  resources :colors, except: [:show]
  resources :labels, except: [:show]
  resources :statuses, except: [:show]
  resources :macro_activities, except: [:index, :show]
  resources :progresses, except: [:show]
  get '/progresses/report_pdf', to: 'progresses#report_pdf', as: 'progress_report_pdf'
  resources :weeks, only: [:edit, :update]

  post '/projects/:id/login', to: 'hours_registries#login', as: 'project_login'
  put '/projects/:id/logout', to: 'hours_registries#logout', as: 'project_logout'

  get 'progresses/graphic' => 'progresses#graphic'

  post 'team_users/edit_multiple'
  put 'team_users/update_multiple'

  get 'home/index'
  root 'home#index'
  # resources :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
