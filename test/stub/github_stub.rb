#dummy stub for Github source
module GithubStub
  class GithubStub
    def repos(*opts)
      repo = opts[0]
      raise Github::Error::NotFound.new({}) unless repo[:user] == "puradawid" and repo[:repo] == "github_stats"
      self
    end

    def commits
      self
    end
    
    def list
      self
    end

    def author
      self
    end

    def [] index
      self
    end

    def commit
      self
    end

    def date
      Date.new.to_s
    end

    def all
      self 
    end
  end
end
