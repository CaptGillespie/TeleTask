Rails.application.routes.draw do

  ActiveAdmin.routes(self)
  # get '/', to: 'application#index'
  resources :commands

  resources :appointments
  resources :patients
  resources :doctors

  resources :doctors, path: "/doctors"
  resources :appointments, only: [:new, :create]
  post "appointments/incoming", to: 'appointments#accept_or_reject', as: 'incoming'

  # Home page
  root 'appointments#requestNew', as: 'home'
  post '/', to: 'appointments#new_appt_req'

end


