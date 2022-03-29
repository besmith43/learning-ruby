Rails.application.routes.draw do
	resources :users do
		collection { post :import }
	end

  root to: "users#index"

  get 'users/index'

  get 'users/import'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
