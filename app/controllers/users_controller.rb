class UsersController < ApplicationController

  before_action :logged_in_user,  only: [:edit, :update, :destroy]
  before_action :only_for_admin,  only: [:destroy]
  before_action :correct_user,    only: [:edit, :update]

  def index
    @users = User.where("options NOT LIKE '9%'").paginate(page: params[:page])
  end

  # Demande d'inscription
  def new
    @user = User.new
  end

  # Soumission de l'inscription, avec création de l'user
  # s'il est valide
  def create
    @user = User.new(user_params)
    if @user.save
      # Icarien.ne OK
      # On lui envoie un mail pour confirmer son adresse email
      @user.create_activation_digest
      # Rediriger vers une page statique expliquant la suite
      redirect_to ('/static_pages/after_signup?id=%i' % [@user.id])
    else
      # Si l'enregistrement n'a pas pu se faire, on réaffiche
      # le formulaire en affichant les erreurs
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
