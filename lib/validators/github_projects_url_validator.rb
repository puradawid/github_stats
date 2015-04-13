class GithubProjectsUrlValidator < ActiveModel::EachValidator

    def validate_each(record, attribute, value)
      if check_github_url value
        repo_data = GithubStats::Parser.parse value
	begin
          Github.repos(user: repo_data[:username], repo: repo_data[:repo]).commits.all
        rescue Exception => e
          record.errors[attribute] << error_message
        end
      else
        record.errors[attribute] << error_message
      end
    end

    def check_github_url(url)
      begin
        parsed_url = URI.parse(url)
        parsed_url.scheme.in? allowed_schemas and parsed_url.hostname == allowed_hostname
      rescue URI::InvalidURIError
        return false
      end
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
end
