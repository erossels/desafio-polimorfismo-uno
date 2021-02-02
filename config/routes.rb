Rails.application.routes.draw do
  resources :payments
  root 'payment_method#form'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
