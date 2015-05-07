class GithubProjectsUrlValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value, github_source = Github)
    add_error_message(record, attribute) unless
      wrong_repo?(value, opts, github_source)
  end

  def wrong_repo?(value, opts, github_source)
    empty_and_allowed(value, opts[:presence]) ||
      (check_github_url(value) &&
       repo_existing?(GithubStats::Parser.parse(value), github_source))
  end

  def empty_and_allowed(url, presence)
    url.empty? && !presence
  end

  def repo_existing?(repo_data, github_source)
    user = repo_data[:username]
    repo = repo_data[:repo]
    begin
      github_source.repos(user: user, repo: repo)
    rescue Github::Error::NotFound
      return false
    end
  end

  def check_github_url(url)
    parsed_url = URI.parse(url)
    parsed_url.scheme.in?(allowed_schemas) &&
      parsed_url.hostname == allowed_hostname
  rescue URI::InvalidURIError
    return false
  end

  private

  def add_error_message(record, attribute)
    record.errors[attribute] << error_message
    record
  end

  def opts
    presence = if options.key? :presence
                 options[:presence]
               else
                 true
               end
    { presence: presence }
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
