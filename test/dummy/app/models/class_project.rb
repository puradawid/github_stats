class ClassProject
  attr_accessor :github_url
  acts_as_github_repo field_name: :github_url
end
