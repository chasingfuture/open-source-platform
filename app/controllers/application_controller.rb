# All controllers MUST inherit from this class.
#
# General controllers behavior are defined here.
# Do NOT define controller-specific behavior here.
class ApplicationController < ActionController::Base

  # CSRF protection
  protect_from_forgery with: :exception

  # make authentication features available in all controllers
  include Authentication

  # helper functions to be used in the views
  helper_method :current_user
  helper_method :authenticated?
  helper_method :user_signed_in?

  # authorization checking is required to be explicit for every action
  check_authorization

  # unauthorize access handling
  rescue_from CanCan::AccessDenied do |exception|
    respond_to do |format|
      format.json { render json: { success: false, message: I18n.t("controllers.application_controller.access_denied") }, status: 401 }
      format.html { redirect_to main_app.root_url, notice: I18n.t("controllers.application_controller.access_denied") }
      format.js   { render json: { success: false, message: I18n.t("controllers.application_controller.access_denied") }, status: 401 }
    end
  end

end
