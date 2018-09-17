require 'github_synchronizer'

# Users-related features
class UsersController < ApplicationController

  # Required authentication
  before_action :authenticate!, only: [:update]

  # Pre-process callbacks
  before_action :fetch_user, only: [:show, :update]

  # Necessary permissions checks
  before_action :update_authorization_check!, only: [:update]

  # Unnecessary permission check
  skip_authorization_check only: [:show]

  # Get /users/:login.
  # Display user profile.
  def show
    # also fetch related projects
    @projects = @user.projects
  end

  # PUT /users/:login
  # Pull Github data to refresh the profile
  def update
    # synchronize
    GithubSynchronizer::synchronize_user session[:github_access_token]

    # notify user of the success
    flash[:success] = I18n.t("controllers.users_controller.update.success")
  rescue => exception
    puts "I KNOW WHAT GOT PRINTED" 
  puts exception
  puts exception.backtrace
    # notify user of the failure
    flash[:error] = I18n.t("controllers.users_controller.update.error")
  ensure
    # always the user detail
    redirect_to user_path(login: @user.login)
  end

  private

  # Fetch the requested user.
  # If the requested user does not exist, render a custom 404 page.
  def fetch_user
    @user = User.find_by(login: params[:login])
  rescue Mongoid::Errors::DocumentNotFound
    render 'users/not_found', status: 404
  end

  # Ensure that the user has the appropriate permission to update the given profile
  def update_authorization_check!
    authorize! :update, @user
  end

end
