class RepositoriesController < ApplicationController

  def index
      github = GithubService.new(@access_hash)
      @username = github.get_username
      @repos_array = github.get_repos
  end

  def create
    github = GithubService.new(@access_hash)
    @new_repo = github.create_repo(params[:name])
    redirect_to '/'
  end
end
