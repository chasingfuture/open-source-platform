class ProjectsController < ApplicationController

  # pre-process callbacks
  before_action :fetch_project, only: [:show]

  # GET /controllers/:slug
  # project detail page
  def show
  end

  private

  # fetch the requested project
  # if the requested project does not exist, render a custom 404 page inviting the user to sync the project
  def fetch_project
    @project = Project.find_by(slug: params[:slug])
  rescue Mongoid::Errors::DocumentNotFound
    render 'projects/not_found', status: 404
  end

end
