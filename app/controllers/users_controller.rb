# Users-related features
class UsersController < ApplicationController

  # Pre-process callbacks
  before_action :fetch_user, only: [:show]

  # Get /users/:login.
  # Display user profile.
  def show
    # also fetch related projects
    @projects = @user.projects
  end

  private

  # Fetch the requested user.
  # If the requested user does not exist, render a custom 404 page.
  def fetch_user
    @user = User.find_by(login: params[:login])
  rescue Mongoid::Errors::DocumentNotFound
    render 'users/not_found', status: 404
  end

end
