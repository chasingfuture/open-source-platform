# Helper to help compose custom urls (slug-based typically)
module LinkHelper

  # Given a user, return a link to its profile
  def compose_user_path(user)
    user_path(login: user.login)
  end

  # Given a user and one of his project, return a link to the project
  def compose_project_path(owner, project)
    user_project_path(user_login: owner.login, platform: project.ext_source, slug: project.slug)
  end

end
