require 'test_helper'

class GithubRepositoryTest < ActiveSupport::TestCase

  test "fetch github url" do
    project = Project.new
    project.github_url = "http://github.com/puradawid/github_stats"
    assert_equal "http://github.com/puradawid/github_stats", project.github_url
  end

  test "fetch github url from ClassProject" do
    project = ClassProject.new
    project.github_url = "http://github.com/puradawid/github_stats"
    assert_equal "http://github.com/puradawid/github_stats", project.github_url
  end

  test "check last commit date by sending no error" do
    project = ClassProject.new 
    project.github_url = "https://github.com/puradawid/github_stats"
    assert_kind_of String, project.last_commit_date
  end
end
