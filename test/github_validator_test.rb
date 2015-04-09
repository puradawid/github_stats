require 'test_helper'
require 'mocha/mini_test'

class GithubStatsValidatorTest < ActiveSupport::TestCase
  def validator
    #instance a validator using regular constructor
    @validator ||= GithubStats::GithubProjectsUrlValidator.new({attributes: {something: "irrelevant"}})
  end

  # testing check_github_url helping method

  def generate_fake_model url, attr_name
    mock.stubs(:errors).returns([])
    mock.stubs(attr_name).returns(url)
  end

  test "validate wrong url to github" do
    assert validator.check_github_url("http://not-a-github.com/username/project") == false
  end

  test "check url for good repo" do
    assert validator.check_github_url("http://github.com/puradawid/github_stats") == true
  end

  test "url without schema" do
    assert validator.check_github_url("github.com/puradawid/github_stats") == false
  end

  # testing real validation

  test "validate right but unexisting github repo" do
    assert false == validate_github_url("https://github.com/puradawid/github_stats_notexisting")
  end

  test "validate right existing github repo" do
    assert true == validate_github_url("https://github.com/puradawid/github_stats")
  end

  private
  def validate_github_url url
    validator.validate_each(
        generate_fake_model(url, :github_url),
        :github_url,
        url)
  end

end