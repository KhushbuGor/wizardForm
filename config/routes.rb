Rails.application.routes.draw do
  resources :users do
    get '/edit_user' => 'users#edit_user'
    put '/edit_user/update' => 'users#update'
  end
  resource :wizard do
    get :step1
    get :step2
    get :step3
    get :step4

    post :validate_step
    get :validate_step
  end

 
  root 'users#index'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end