# Octokit wrapper.
# High level github interactions.
module GithubAPI

  # Return the full url for OAuth login.
  def self.oauth_login_url
    Octokit.authorize_url GITHUB_API_CLIENT_INFO[:id], scope: "user:email"
  end

  # Given a temporary OAuth code, reach out to Github API to convert it into an access token
  def self.oauth_exchange_code_for_token(code)
    # contact github for the exchange
    response = Octokit.exchange_code_for_token code, GITHUB_API_CLIENT_INFO[:id], GITHUB_API_CLIENT_INFO[:secret]

    # return the access token
    response[:access_token]
    end

    # Get the github profile associated to the access token
    def self.profile(access_token)
      Octokit::Client.new(access_token: access_token).user
    end

    # Get the github public repositories associated to the access token
    def self.public_repositories(access_token)
      Octokit::Client.new(access_token: access_token).repositories
    end

end
