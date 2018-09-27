Rails.application.routes.draw do

  get 'ic_modules/show'
  get 'ic_modules/update'
  get 'ic_modules/new'
  get 'ic_modules/create'
  ActiveAdmin.routes(self)
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
  # => edit_user_path(user) => "users#edit"
  get 'signup'      => 'users#new'
  post 'signup'     => 'users#create'
  get 'profil'      => 'users#show'

  get 'static_pages/after_signup' # route rejointe après l'inscription

  # = sessions =
  get  'login'  => 'sessions#new'
  post 'login'  => 'sessions#create'
  get  'logout' => 'sessions#destroy'

  # = bureau =
  get 'bureau'      => 'bureau#home'
  get 'historique'  => 'bureau#historique'
  get 'documents'   => 'bureau#documents'

  # === TICKETS ===
  # resources :tickets
  get 'tickets/new' => 'tickets#create'
  # get 'tickets/run/:id' => 'tickets#run'
  get 'tickets/:id/:token' => 'tickets#run', as: 'ticket_run'


  # === MODULES D'APPRENTISSAGE ===

  # Concernant les modules d'apprentissage
  resources :abs_modules
  resources :abs_etapes


  # === Mot de passe réinitialisation ===
  resources :password_resets, only: [:new, :create, :edit, :update]
  # get 'password_resets/new'
  # get 'password_resets/edit'

end
