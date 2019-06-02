Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get 'users/authorize', to: 'users#authorize'
  get 'users/callback', to: 'users#callback'
end