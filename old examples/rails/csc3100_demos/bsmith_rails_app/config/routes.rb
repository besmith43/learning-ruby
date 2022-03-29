Rails.application.routes.draw do

  resources :references
  resources :skills_and_interests
  resources :honors_and_awards
  resources :work_experiences
  resources :courses
  devise_for :users

  root to: "dashboard#index"
  get 'dashboard/page1'
  get 'dashboard/page2'
  get 'dashboard/experience'
  get 'dashboard/honors'
  get 'dashboard/skills'
  get 'dashboard/references'
  
  resources :users

end
