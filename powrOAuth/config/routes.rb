Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get '/login', to: 'login#show'
  get 'login/gohub', to: 'login#gohub'
  get '/callback', to: 'application#callback'
  get 'pages/edit', to: 'pages#edit'
  post 'pages/update', to: 'pages#update'
  post 'pages/rollback', to: 'pages#rollback'
end