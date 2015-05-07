# dummy stub for Github source
module GithubStub
  # Class GithubStub is a safe replacement for Github module from
  # https://github.com/peter-murach/github
  class GithubStub
    def repos(*opts)
      repo = opts[0]
      unless repo[:user] == "puradawid" && repo[:repo] == "github_stats"
        fail Github::Error::NotFound.new({}), "Error"
      end
      self
    end

    def commits(*)
      self
    end

    def list(*)
      self
    end

    def author(*)
      self
    end

    def [](*)
      self
    end

    def commit(*)
      self
    end

    def date(*)
      Date.new.to_s
    end

    def all(*)
      self
    end
  end
end
