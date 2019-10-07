Rails.application.routes.draw do
  root to: 'pages#index'
  post 'deliveryValid', to: 'pages#deliveryValid'
  post 'initiateCart', to: 'pages#initiateCart'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
