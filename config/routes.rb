Rails.application.routes.draw do
  resources :users
  resource :wizard do
    get :step1
    get :step2
    get :step3
    get :step4

    post :validate_step
  end

 
  root 'users#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end