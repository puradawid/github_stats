module GithubStats
  class GithubProjectsUrlValidator < ActiveModel::EachValidator

    def validate_each(record, attribute, value)
      if check_github_url value
        url = URI.parse(value)
        repo_data = github_data value
        byebug
        begin
          Github.repos(user: repo_data[:username], repo: repo_data[:repo]).commits.all
        rescue Exception => e
          record.records[attribute] << error_message
        end
      else
        record.records[attribute] << error_message
      end
    end

    def check_github_url(url)
      parsed_url = URI.parse(url)
      parsed_url.scheme.in? allowed_schemas and parsed_url.hostname == allowed_hostname
    end

    private

    def error_message
      "It is not existing github record."
    end

    def allowed_schemas
      ["http", "https", ""]
    end

    def allowed_hostname
      "github.com"
    end

    def github_data url
      path = URI.parse(url).path.split '/'
      {username: path[1], repo: path[2]}
    end

  end
end