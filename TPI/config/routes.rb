Rails.application.routes.draw do

  resources :users
  devise_for :users, :skip => [:registrations], :path_prefix => 'auth'

  root to: 'professionals#index'

  resources :grids
  post 'grid_create', to: 'grids#grid_create'

  resources :professionals do
    member do
      delete 'cancel_all_appointments', action: 'destroy_all_appointments'
    end
    resources :appointments
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
