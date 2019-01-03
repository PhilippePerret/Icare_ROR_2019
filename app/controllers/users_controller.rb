class UsersController < ApplicationController

  before_action :logged_in_user,  only: [:edit, :update, :destroy]
  before_action :only_for_admin,  only: [:destroy]
  before_action :correct_user,    only: [:edit, :update]

  before_action :load_module_user_signup, only: [:new, :create]

  def index
    # Filtre différent en fonction du fait qu'il s'agisse d'un
    # administrateur ou non
    f = ["SUBSTRING(options,1,1) NOT IN ('0','9')"] # ni non validé ou détruit
    f << "SUBSTRING(options,3,1) = '1'" # inscription complète
    f << "SUBSTRING(options,2,1) = '1'" # mail confirmé
    filtre = current_user.admin? ? "options NOT LIKE '9%'" : f.join(' AND ')
    @users = User.where(filtre).paginate(page: params[:page])
  end

  # Demande d'inscription.
  # Mais l'on repasse aussi par ici lorsque des erreurs ont été trouvées en
  # essayant d'enregistrer la candidature du postulant. Donc soit on crée une
  # toute nouvelle instance pour l'user, soit on prend l'user enregistré.
  def new
    if current_user.real?
      @user = current_user
    else
      @user = User.new
    end
  end

  # Soumission de l'inscription, avec création de l'user
  # s'il est valide
  def create

    # Par prudence, dans le cas où, en développement, on aurait une connexion
    # à la base déjà ouverte
    if Rails.env.development?
      ActiveRecord::Base.connection.execute("BEGIN TRANSACTION;")
      ActiveRecord::Base.connection.execute("END;")
    end

    if current_user.real?
      @user = current_user
    else
      @user = User.new(user_params)
      if @user.save
        set_current_user(@user)
      else
        render :new
        return
      end
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
      unless @user.candidature_complete?
        flash.now[:danger] = I18n.t('users.candidature.errors.incomplete')
      end
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


    def load_module_user_signup
      require Rails.root.join('lib','action_watchers','user','create_candidature','user')
    end

  # /private

end
