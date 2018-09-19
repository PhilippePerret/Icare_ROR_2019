class PagesController < ApplicationController
  def home
    @pseudo_user = @user || "Ernest"
  end
end
