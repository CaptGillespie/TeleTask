Rails.application.routes.draw do

  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  get '/', to: 'application#index'
  resources :commands

  resources :appointments
  resources :patients
  resources :doctors

  resources :doctors, path: "/doctors"
  resources :appointments, only: [:new, :create]
  post "appointments/incoming", to: 'appointments#accept_or_reject', as: 'incoming'
  # Home page
  # root 'appointments#requestNew', as: 'home'
  post '/doctorAppt', to: 'appointments#doctor_Appt'

end


