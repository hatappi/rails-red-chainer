Rails.application.routes.draw do
  root 'cnn/models#index'
  namespace :cnn do
    resources :models, param: :model_name
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
