require 'github_api'

# Wrap methods handling data synchronization from Github API
module GithubSynchronizer

  # Synchronize all data related to currently signed in user using its Github access token.
  # Basically  pull its profile and repositories.
  # Update information already available on our side and create those not already pulled.
  # Return an hash { user: user, repositories: repositories } containing the updated and created resources
  def self.synchronize_user(access_token)
    # sync
    user  = synchronize_profile access_token
    repos = synchronize_repositories access_token, user

    # return updated or created resources
    { user: user, repositories: repos }
  end

  # Synchronize currently signed in user profile using its Github access token.
  # Basically pull its github profile.
  # If the profile does not exist yet on our side, create it.
  # Return the created or updated user profile
  def self.synchronize_profile(access_token)
    # fetch github profile information
    github_profile = GithubAPI::profile access_token

    # try to fetch user profile in DB
    user = User.find_or_initialize_by(github_ext_id: github_profile[:id])

    # setup or update profile
    user.login      = github_profile[:login]
    user.name       = github_profile[:name]
    user.email      = github_profile[:email]
    user.avatar_url = github_profile[:avatar_url]
    user.save!

    # return created or updated user profile
    user
  end

  # Synchronize currently signed in user repositories using its Github access token.
  # Basically pull its github repositories.
  # If the repositories do not exist yet on our side, create them.
  # 'user' param is a User object that should be linked to the pulled repositories
  # Return the created or updated repositories.
  def self.synchronize_repositories(access_token, user)
    # fetch github repositories information
    github_repositories = GithubAPI::public_repositories access_token

    # iterate over each returned repository
    github_repositories.collect do |repo|
      # try to fetch repo in DB
      project = Project.find_or_initialize_by(ext_id: repo[:id], ext_source: Platform::GITHUB)

      # skip if not the owner
      next if repo[:owner][:login] != user[:login]

      # setup or update repo
      project.slug           = repo[:name] # github repo name act as name and slugs
      project.name           = repo[:name]
      project.description    = repo[:description]
      project.repository_url = repo[:url]
      project.git_url        = repo[:git_url]
      project.homepage_url   = repo[:homepage]
      project.owner          = user
      project.save!

      # return created or updated project
      project
    end
  end

end
