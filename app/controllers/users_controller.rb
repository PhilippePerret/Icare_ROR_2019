class UsersController < ApplicationController

  before_action :logged_in_user,  only: [:edit, :update, :destroy]
  before_action :only_for_admin,  only: [:destroy]
  before_action :correct_user,    only: [:edit, :update]

  def index
    @users = User.where("options NOT LIKE '9%'").paginate(page: params[:page])
  end

  # Demande d'inscription.
  # Mais l'on repasse aussi par ici lorsque des erreurs ont été trouvées en
  # essayant d'enregistrer la candidature du postulant. Donc soit on crée une
  # toute nouvelle instance pour l'user, soit on prend l'user enregistré.
  def new
    @user = current_user.real? ? current_user : User.new
  end

  # Soumission de l'inscription, avec création de l'user
  # s'il est valide
  def create

    # # Pour détruire l'user créé avant (test)
    # if u = User.find_by_name('filou')
    #   u.destroy
    #   set_current_user(nil)
    # end
    #

    if current_user.real?
      @user = current_user
    else
      @user = User.new(user_params)
      @user.save || begin
        render :new
        return
      end
      set_current_user(@user)
    end

    # L'idée ici est de créer un watcher pour le candidat et de le
    # jouer aussitôt. De cette manière, tout le processus de création de la
    # candidature, avec enregistrement des documents et des modules optionnés,
    # se trouve dans un endroit qu'on peut retrouver facilement.
    aw = @user.action_watchers.create(objet: @user, action: 'user/create_candidature')
    aw.is_a?(ActionWatcher) || raise('Impossible de créer la candidature…')
    aw.run_for(@user, params)

    if aw.success?
      redirect_to ('/static_pages/after_signup?id=%i' % [@user.id])
    else
      render :new
    end
  end


  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      # OK
      flash[:success] = "Vos informations ont été actualisées."
      redirect_to profil_path
    else
      render 'edit'
    end
  end

  def show
    @user =
      if params[:id]
        User.find(params[:id])
      else
        current_user
      end
  end

  def edit
    @user =
      if params[:id]
        User.find(params[:id])
      else
        current_user
      end
  end

  # Pour détruire l'icarien(ne) voulu(e)
  def destroy
    u = User.find(params[:id])
    u.destroy
    flash[:success] = "#{u.name} a été supprimé avec succès."
    redirect_to users_path
  end

  private

    def user_params
      params.require(:user).permit(
        :name, :email, :nom, :prenom, :sexe, :birthyear,
        :password, :password_confirmation
      )
    end


  # /private

end
