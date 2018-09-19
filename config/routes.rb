Rails.application.routes.draw do
  get 'abs_modules/index'
  get 'modules/:id' => 'abs_modules#show'
  patch 'modules/:id' => 'abs_modules#update'
  delete 'modules/:id' => 'abs_modules#destroy'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root 'pages#home'

  get 'home' => 'pages#home'

  get   'modules' => 'abs_modules#index'
  # Création d'un module
  post  'modules'  => 'abs_modules#create'

end
