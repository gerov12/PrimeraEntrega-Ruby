Rails.application.routes.draw do

  root to: 'professionals#index'

  resources :professionals do
    member do
      delete 'cancel_all_appointments', action: 'destroy_all_appointments'
    end
    resources :appointments
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
