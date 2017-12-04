# All controllers MUST inherit from this class.
#
# General controllers behavior are defined here.
# Do NOT define controller-specific behavior here.
class ApplicationController < ActionController::Base

  protect_from_forgery with: :exception

end
