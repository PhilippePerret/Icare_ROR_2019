class UsersController < ApplicationController

  before_action :logged_in_user, only: [:edit, :update]

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
      log_in @user
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

  private

    def user_params
      params.require(:user).permit(
        :name, :email, :sexe, :annee_naissance,
        :password, :password_confirmation
      )
    end

    def logged_in_user
      return if current_user? && (params[:id].nil? || current_user.id == params[:id].to_i)
      store_original_url
      flash[:danger] = "Merci de vous identifier pour accomplir cette action."
      redirect_to login_url
    end
end
