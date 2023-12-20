Rails.application.routes.draw do

  resources :appointments
  resources :patients
  resources :doctors

  resources :doctors, path: "/properties"
  resources :appointments, only: [:new, :create]
  post "appointments/incoming", to: 'appointments#accept_or_reject', as: 'incoming'

  # Home page
  root 'main#index', as: 'home'

end


