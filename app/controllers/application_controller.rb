# All controllers MUST inherit from this class.
#
# General controllers behavior are defined here.
# Do NOT define controller-specific behavior here.
class ApplicationController < ActionController::Base

  # CSRF protection
  protect_from_forgery with: :exception

  # helper functions to be used in the views
  helper_method :current_user
  helper_method :authenticated?
  helper_method :user_signed_in?

  # If the current user information are already available, return the current user information.
  # Otherwise, call authenticate to set the current user information and return it.
  # Returns nil if user is not authenticated.
  def current_user
    @current_user ||= authenticate
  end

  # Return whether the user is authenticated or not.
  def authenticated?
    current_user.present?
  end

  # Same as authenticated?, just for convenience purpose
  def user_signed_in?
    authenticated?
  end

  # Authenticate the user based on session information.
  def authenticate
    # skip if already authenticated
    # skip if no valid session information
    if @current_user.nil? && session[:user_id].present?
      # find user based on user id stored in the session
      @current_user = User.find(session[:user_id])
    end

    # return current user information
    @current_user
  end

  # Same as authenticate, except that it redirects to the login path if the user is not authenticated.
  # Ensure user is authenticated and set the current user information.
  # Meant to be used in a before_action filter.
  def authenticate!
    redirect_to login_path unless authenticate
  end

end
