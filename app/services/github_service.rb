class GithubService
  attr_accessor :access_token

  def initialize(access_hash = {})
    @access_token = access_hash['access_token']
  end

  def authenticate!(client_id, client_secret, code)
    response = Faraday.post "https://github.com/login/oauth/access_token", {client_id: client_id, client_secret: client_secret, code: code}, {'Accept' => 'application/json'}
    access_hash = JSON.parse(response.body)
    @access_token = access_hash["access_token"]

  end

  def get_username
    user_response = Faraday.get "https://api.github.com/user", {}, {'Authorization' => "token #{@access_token}", 'Accept' => 'application/json'}
    user_json = JSON.parse(user_response.body)
    user_json["login"]
  end

  def get_repos

    repos = Faraday.get "https://api.github.com/user/repos", {}, {'Authorization' => "token #{@access_token}", 'Accept' => 'application/json'}

    #  JSON.parse(repos.body)
    JSON.parse(repos.body).map do |repo|
        binding.pry
       GithubRepo.new(repo)
    end
  end

  def create_repo(name)
     Faraday.post "https://api.github.com/user/repos", {name: name}.to_json, {'Authorization' => "token #{@access_token}", 'Accept' => 'application/json'}
      # binding.pry
      # JSON.parse(response.body)
  end

end
