require 'test_helper'

class GithubRepositoryTest < ActiveSupport::TestCase

  test "fetch github url" do
    project = Project.new
    project.github_url = "http://github.com/puradawid/github_stats"
    assert_equal "http://github.com/puradawid/github_stats", project.github_url
  end
end