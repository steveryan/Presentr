import Config

github_token =
  System.get_env("GITHUB_TOKEN") ||
    raise """
    No github token found in env variables
    """

config :presentr,
  token: github_token
