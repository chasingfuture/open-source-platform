require 'github'

# Handles all logic related to sessions: oauth & signout
class SessionsController < ApplicationController

  before_action :already_authenticated!, only: [:new, :create]
  before_action :authenticate!,          only: [:destroy]

  # GET /login
  # for now, directly redirects to github handler as only github is supported for auth
  # if the user is already authenticated, redirect to root path as there is nothing to do
  def new
    redirect_to Github::oauth_login_url
  end

  # GET /oauth/callback/github
  # Github OAuth API callback
  # Sign in the user (and creates an account if necessary)
  def create
    # convert code into access token
    access_token = Github::oauth_exchange_code_for_token params[:code]

    # fetch github profile information
    github_profile = Github::profile access_token

    # try to fetch user profile in DB
    user = User.find_or_initialize_by(github_ext_id: github_profile[:id])

    # setup or update profile
    user.login      = github_profile[:login]
    user.name       = github_profile[:name]
    user.email      = github_profile[:email]
    user.avatar_url = github_profile[:avatar_url]
    user.save!

    # setup session
    session[:github_access_token] = access_token
    session[:user_id]             = user.id

    # notify the user of the success
    flash[:success] = I18n.t('controllers.sessions_controller.create.success')
  rescue Exception => e
    # notify the user of the failure
    flash[:error] = I18n.t('controllers.sessions_controller.create.error')
  ensure
    # always redirect to the main page
    redirect_to root_path
  end

  # DELETE /logout
  # logout the user by erasing its session
  def destroy
    # reset session
    reset_session
    # redirect to the home page
    redirect_to root_path
  end

end
