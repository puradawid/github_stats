class Project < ActiveRecord::Base
  attr_accessor :repo_github
  acts_as_github_repo field_name: :repo_github
  validates :repo_github, github_projects_url: { presence: false }
end
