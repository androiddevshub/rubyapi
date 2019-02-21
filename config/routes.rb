Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  #add our register route
  get 'users', to: 'users#index'
  post 'user/register', to: 'users#register'
  post 'user/send_otp', to: 'users#send_otp'
  post 'user/login', to: 'users#login'

end
