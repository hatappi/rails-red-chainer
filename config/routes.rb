Rails.application.routes.draw do
  namespace :cnn do
    resources :models
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
