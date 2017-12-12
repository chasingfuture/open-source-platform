# Special controller meant to handle GET /
class RootController < ApplicationController

  # unnecessary permission check
  skip_authorization_check only: [:index]

  # GET /
  def index
  end

end
