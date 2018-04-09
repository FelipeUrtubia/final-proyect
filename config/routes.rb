Rails.application.routes.draw do
  devise_for :users

  resources :products, only: :index do
    resources :orders, only: [:create]
  end

  delete 'orders/destroy_all'

  resources :orders, only: [:index, :destroy]

  get 'vistas/contacto'
  get 'vistas/quienessomos'
  get 'vistas/redessociales'
  get 'vistas/servicios'

  root 'products#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
