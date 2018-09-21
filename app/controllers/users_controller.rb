class UsersController < ApplicationController

  # Demande d'inscription
  def new
    @user = User.new
  end

  # Soumission de l'inscription, avec création de l'user
  # s'il est valide
  def create
    @user = User.new(user_params)
    if @user.save
      # OK
      render :show # pour le moment
      # TODO Rediriger vers une page statique expliquant la suite
      # redirect_to 'static_pages#after_signup'
    else
      # Si l'enregistrement n'a pas pu se faire, on réaffiche
      # le formulaire en affichant les erreurs
      render :new
    end
  end

  def show
    @user = User.find(params[:id])
  end

  private

    def user_params
      params.require(:user).permit(
        :name, :email, :sexe, :annee_naissance,
        :password, :password_confirmation
      )
    end
end
