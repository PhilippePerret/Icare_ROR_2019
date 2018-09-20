Rails.application.routes.draw do
  get 'static_pages/home'
  get 'static_pages/help'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root 'static_pages#home'

  get 'home' => 'static_pages#home'
  get 'help' => 'static_pages#help'

  # Concernant les modules d'apprentissage
  get 'abs_modules/index'
  get 'modules/:id' => 'abs_modules#show'
  patch 'modules/:id' => 'abs_modules#update'
  delete 'modules/:id' => 'abs_modules#destroy'
  get   'modules' => 'abs_modules#index'
  # Création d'un module
  post  'modules'  => 'abs_modules#create'

end
