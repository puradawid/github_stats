module GithubStats
  module GithubRepository
    def self.included(base)
      base.extend(ClassMethods)
    end
    
    module ClassMethods
      def has_github_repo options = {}
        cattr_accessor :github_url_field
        self.github_url_field = (options[:field_name] || :github_url).to_s

        include GithubStats::GithubRepository::LocalInstanceMethods
      end
    end

    module LocalInstanceMethods
      
      def last_commit_date
	return "" if empty?
	commits = repo(Parser.parse(github_url_address)).commits 
        commits.list[0].commit.author.date
      end

      private 
      def github_url_address
        send(self.class.github_url_field)
      end

      def empty?
        github_url_address.empty?
      end

      def repo data
        Github.repos(user: data[:username], repo: data[:repo])
      end
    end
  end
end

Object.send :include, GithubStats::GithubRepository
