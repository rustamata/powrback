Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'login#show'
  get '/login', to: 'login#show'
  post '/login/oauth', to: 'login#oauth'
  get '/login/logout', to: 'login#logout'
  get '/callback', to: 'login#callback'
  get '/pages/edit', to: 'pages#edit'
  post '/pages/update', to: 'pages#update'
  post '/pages/rollback', to: 'pages#rollback'
end