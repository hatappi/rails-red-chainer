Rails.application.routes.draw do
  root 'cnn/models#index'
  namespace :cnn do
    resources :models, param: :model_name, only: %i(index show)
  end
end
