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

end
