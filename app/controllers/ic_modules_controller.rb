class IcModulesController < ApplicationController

  before_action :only_for_admin,  except: [:show]

  # Pour la commande d'un nouveau module d'apprentissage
  # @Réservé à l'administration
  def new
  end

  # Pour la création du module d'apprentissage, c'est-à-dire que
  # c'est moi, Phil, qui l'accorde  l'user
  # @Réservé à l'administration
  def create
    module_data = params[:module]
    user = User.find(module_data[:user_id])
    flash.now[:success] = "J'ai créé le module #{module_data[:abs_module]} pour #{user}"

    user.ic_modules.create(
      abs_module_id:  module_data[:abs_module],
      current_etape:  nil,
      started_at:     nil
    )

    params[:user_id] = user.id
    render :show
  end

  # Modification des données du module d'apprentissage de l'icarien
  def update
  end


  # Affichage du module icarien, toutes ses informations, ses étapes,
  # ses documents.
  def show

  end

  # Liste des modules d'apprentissage de l'icarien (si params[:user_id] est
  # défini), de tous les modules d'apprentissage si l'user est un administrateur
  # ou de l'icarien courant si current_user n'est pas un administrateur
  def index
    @ic_modules =
      if current_user
        if current_user.admin?
          if params[:user_id] # les modules d'un seul icarien
            User.find(params[:user_id]).ic_modules
          else # tous les modules d'icarien
            # TODO Possibilité d'avoir un filtre, qui permette de choisir
            # seulement les modules d'un certain type, suivant une date, etc.
            IcModule.all
          end
        else
          current_user.ic_modules
        end
      else
        flash[:danger] = I18n.t('page.errors.interdite')
        redirect_to home_path
      end
  end
end
