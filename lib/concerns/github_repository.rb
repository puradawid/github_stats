module GithubStats
  module GithubRepository
    extend ActiveSupport::Concern

    included do
    end

    module ClassMethods
      def has_github_repo options = {}
        cattr_accessor :github_url_field
        self.github_url_field = (options[:field_name] || :github_url).to_s

        include GithubStats::GithubRepository::LocalInstanceMethods
      end
    end

    module LocalInstanceMethods
      extend ActiveSupport::Concern
      attr_accessor :github_url
      included do
        validates :github_url, presence:true
      end
    end
  end
end

ActiveRecord::Base.send :include, GithubStats::GithubRepository