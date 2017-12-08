require 'github'

# Handles all logic related to registration (mostly deal with OAuth providers)
class RegistrationController < ApplicationController

  # GET /login
  # for now, directly redirects to github handler as only github is supported for auth
  # if the user is already authenticated, redirect to root path as there is nothing to do
  def login
    if authenticated?
      redirect_to root_path
    else
      redirect_to Github::oauth_login_url
    end
  end

  # GET /oauth/callback/github
  # Github OAuth API callback
  # Sign in the user (and creates an account if necessary)
  def login_via_github
    # convert code into access token
    access_token = Github::oauth_exchange_code_for_token params[:code]

    # fetch github profile information
    github_profile = Github::profile access_token

    # try to fetch user profile in DB
    user = User.find_or_initialize_by(github_ext_id: github_profile[:id])

    # setup or update profile
    user.name       = github_profile[:name]
    user.email      = github_profile[:email]
    user.avatar_url = github_profile[:avatar_url]
    user.save!

    # setup session
    session[:github_access_token] = access_token
    session[:user_id]             = user.id

    # notify the user of the success
    flash[:success] = I18n.t('controllers.registration_controller.login_via_github.success')
  rescue Exception => e
    # notify the user of the failure
    flash[:error] = I18n.t('controllers.registration_controller.login_via_github.error')
  ensure
    # always redirect to the main page
    redirect_to root_path
  end

end
