module GithubStats
  module Parser
    def self.parse(url)
      path = URI.parse(url).path.split "/"
      { username: path[1], repo: path[2] }
    end
  end
end
