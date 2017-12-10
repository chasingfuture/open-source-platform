# Contains all helper method to handle authentication within controllers.
# Basically, functions to authenticate a user, get its authentication status or filter users depending on their status.
module Authentication

  # make it a concern
  extend ActiveSupport::Concern

  # If the current user information are already available, return the current user information.
  # Otherwise, call authenticate to set the current user information and return it.
  # Returns nil if user is not authenticated.
  def current_user
    @current_user ||= authenticate_with_session
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
  def authenticate_with_session
    # skip if already authenticated
    # skip if no valid session information
    if @current_user.nil? && session[:user_id].present?
      # find user based on user id stored in the session
      @current_user = User.find(session[:user_id]) rescue nil
    end

    # return current user information
    @current_user
  end

  # Same as authenticate, except that it redirects to the login path if the user is not authenticated.
  # Ensure user is authenticated and set the current user information.
  # Meant to be used in a before_action filter.
  def authenticate!
    redirect_to login_path unless authenticate_with_session
  end

  # Opposite of authenticate!.
  # If the user is already authenticated or can be authenticated based on its session, redirect him to homepage
  def already_authenticated!
    redirect_to root_path if user_signed_in?
  end

end
