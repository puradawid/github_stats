class Project < ActiveRecord::Base
  has_github_repo field_name: :repo_github

  validates :repo_github, github_projects_url: {presence: false}
end
