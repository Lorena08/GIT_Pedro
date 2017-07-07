class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :authenticate_user!

  layout :layout_by_resource

  # load_and_authorize_resource unless :home_controller?

  include ApplicationHelper

  private

  def layout_by_resource
    if devise_controller?
      "devise"
    else
      "application"
    end
  end

  # def home_controller?
  #   if params[:controller] == 'home'
  #     true
  #   else
  #     false
  #   end
  # end

end
