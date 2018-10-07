Rails.application.routes.draw do

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  # ACCUEIL (URL de base)
  root 'static_pages#home'

  # === P A G E S   S T A T I Q U E S ===

  get 'home'    => 'static_pages#home'
  get 'help'    => 'static_pages#help'
  get 'about'   => 'static_pages#about'
  get 'contact' => 'static_pages#contact'

  # === ACTIONS-WATCHERS ===

  resources :action_watchers, only: [:destroy]
  post 'action_watchers/:id/run' => 'action_watchers#run', as: 'awrun'
  # get 'action_watchers/:id/destroy'


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


  # === MODULES D'APPRENTISSAGE DE L'ICARIEN (ICMODULES) ===
  resources :ic_modules
  resources :ic_etapes

  # === DOCUMENTS ===
  resources :ic_documents
  get 'ic_documents/download'

  get 'ic_etapes/:id/share' => 'ic_etapes#document_sharing'


  # === TICKETS ===
  # resources :tickets
  get 'tickets/new'         => 'tickets#create'
  get 'tickets/:id/:token'  => 'tickets#run', as: 'ticket_run'


  # === MODULES D'APPRENTISSAGE ===

  # Concernant les modules d'apprentissage
  resources :abs_modules
  resources :abs_etapes

  # === AIDE ===
  resources :aide, only: [:show, :index]
  get 'aide/search'

  # === Mot de passe réinitialisation ===
  resources :password_resets, only: [:new, :create, :edit, :update]
  # get 'password_resets/new'
  # get 'password_resets/edit'

end
