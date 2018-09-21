Rails.application.routes.draw do

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  # ACCUEIL (URL de base)
  root 'static_pages#home'

  # === PAGES STATIQUES ===

  get 'home'    => 'static_pages#home'
  get 'help'    => 'static_pages#help'
  get 'about'   => 'static_pages#about'
  get 'contact' => 'static_pages#contact'


  # === U T I L I S A T E U R S ===
  resources :users # => REST
  get 'signup' => 'users#new'
  post 'signup' => 'users#create'

  get 'static_pages/after_signup'

  # Concernant les modules d'apprentissage
  get 'abs_modules/index'
  get 'modules/:id' => 'abs_modules#show'
  patch 'modules/:id' => 'abs_modules#update'
  delete 'modules/:id' => 'abs_modules#destroy'
  get   'modules' => 'abs_modules#index'
  # Création d'un module
  post  'modules'  => 'abs_modules#create'

end
