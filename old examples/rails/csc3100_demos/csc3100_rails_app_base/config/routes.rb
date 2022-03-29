Rails.application.routes.draw do
  resources :experiences
#  get 'users/show'

  devise_for :users
  
  root to: "dashboard#index"
  get 'dashboard/index'
  get 'dashboard/page1'
  get 'dashboard/page2'
  
  resources :users

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
