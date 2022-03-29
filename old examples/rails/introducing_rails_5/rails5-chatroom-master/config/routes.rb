Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root to: 'rooms#index'
  resources :rooms, only: [:index, :show]
  resources :messages, only: [:create]

  get '/login' => 'sessions#new'
  post '/login' => 'sessions#create'
  get '/logout' => 'sessions#destroy' 

  # Serve websocket cable requests in-process
  mount ActionCable.server => '/cable'
end
