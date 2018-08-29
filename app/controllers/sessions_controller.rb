require 'github_api'
require 'github_synchronizer'

# Handles all logic related to sessions: oauth & signout
class SessionsController < ApplicationController

  # authentication status verification
  before_action :already_authenticated!, only: [:new, :create]
  before_action :authenticate!,          only: [:destroy]

  # unnecessary permission check
  skip_authorization_check only: [:new, :create, :destroy]

  # GET /login
  # for now, directly redirects to github handler as only github is supported for auth
  # if the user is already authenticated, redirect to root path as there is nothing to do
  def new
    redirect_to GithubAPI::oauth_login_url
  end

  # GET /oauth/callback/github
  # Github OAuth API callback
  # Sign in the user (and creates an account if necessary)
  def create
    # convert code into access token
    access_token = GithubAPI::oauth_exchange_code_for_token params[:code]
    puts "access token"
    puts access_token.to_s()

    # Sync user profile and repositories
    user = GithubSynchronizer::synchronize_profile access_token
    puts "user"
    puts user.to_s()

    # setup session
    session[:github_access_token] = access_token
    session[:user_id]             = user.id

    # notify the user of the success
    flash[:success] = I18n.t('controllers.sessions_controller.create.success')
  rescue Exception => e
    # notify the user of the failure
    puts e.to_s()
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
