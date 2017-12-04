# Listing and display of projects available on the website is handled here
#
# Be cautious concerning permissions as this part mixes both public and restricted information/actions
class ProjectsController < ApplicationController

  # Pre-process callbacks
  before_action :fetch_project, only: [:show]

  # GET /controllers/:slug
  def show
  end

  private

  # Fetch the requested project.
  # If the requested project does not exist, render a custom 404 page inviting the user to sync the project
  def fetch_project
    @project = Project.find_by(slug: params[:slug])
  rescue Mongoid::Errors::DocumentNotFound
    render 'projects/not_found', status: 404
  end

end
