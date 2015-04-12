class Project < ActiveRecord::Base
  has_github_repo field_name: :repo_github
end
