$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "github_stats/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "github_stats"
  s.version     = GithubStats::VERSION
  s.authors     = ["Pura Dawid"]
  s.email       = ["puradawid@gmail.com"]
  s.homepage    = "https://github.com/puradawid/github_stats"
  s.summary     = "Project repository model wrapper and statistic fetcher."
  s.description = ""
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 4.1.8"
  s.add_dependency "github_api"

  s.add_development_dependency "sqlite3"
end
