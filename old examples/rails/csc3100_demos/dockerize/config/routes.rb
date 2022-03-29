Rails.application.routes.draw do
  resources :lost_forms
  resources :pet_forms
  devise_for :admins
  devise_for :users

  root to: "dashboard#index"

  get 'dashboard/index'

  get 'dashboard/page1'

  get 'dashboard/page2'
	
  get 'dashboard/adoptable'

  get 'dashboard/resources'

  get 'dashboard/support'

  get 'dashboard/lost_pets'

  get 'dashboard/found_pets'

  get 'dashboard/lost_form'

  get 'dashboard/found_form'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
