class GithubProjectsUrlValidator < ActiveModel::EachValidator

    def validate_each(record, attribute, value)
      return if value.empty? and not opts[:presence]
      if check_github_url value
        repo_data = GithubStats::Parser.parse value
	begin
          Github.repos(user: repo_data[:username], repo: repo_data[:repo]).commits.all
        rescue Github::Error::NotFound => e
	  p e
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

    def opts
       presence = if options.has_key? :presence 
                   options[:presence]
		  else 
                    true
                  end
       return {presence: presence}
    end

    def error_message
      "It is not existing github repository."
    end

    def allowed_schemas
      ["http", "https", ""]
    end

    def allowed_hostname
      "github.com"
    end
end
