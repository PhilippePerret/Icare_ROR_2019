class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  # Classes incluses
  include SessionsHelper
  include TicketsHelper

  def home

  end
end
