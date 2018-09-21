class StaticPagesController < ApplicationController
  # def home
  # end
  #
  # def help
  # end
  #
  # def about
  # end

  # def contact
  # end

  def after_signup
    @user = User.find(params[:id])
  end
end
