require "test_helper"
require "mocha/mini_test"
require "byebug"
require "stub/github_stub.rb"

class GithubStatsValidatorTest < ActiveSupport::TestCase
  def validator
    # instance a validator using regular constructor
    @validator ||= GithubProjectsUrlValidator.new(presence: false,
                                                  attributes: { a: false })
  end

  def assert_false(expression)
    assert expression == false
  end

  # testing check_github_url helping method

  def generate_fake_model
    record = mock("model")
    record.stubs("errors").returns([])
    record.errors.stubs("[]").returns({})
    record
  end

  test "validate wrong url to github" do
    assert_false(
      validator.check_github_url("http://not-a-github.com/username/project"))
  end

  test "check url for good repo" do
    assert(
      validator.check_github_url("http://github.com/puradawid/github_stats"))
  end

  test "url without schema" do
    assert_false(
      validator.check_github_url("github.com/puradawid/github_stats"))
  end

  # testing real validation

  test "validate right but unexisting github repo" do
    url = "https://github.com/puradawid/github_stats_notexisting"
    validate_github_url(url) do |model|
      model.errors.[].expects("<<").once
    end
  end

  test "validate right existing github repo" do
    validate_github_url("https://github.com/puradawid/github_stats") do |model|
      model.errors.[].expects("<<").never
    end
  end

  test "validate wrong url" do
    validate_github_url("this is not a url at all") do |model|
      model.errors.[].expects("<<").once
    end
  end

  test "validate url to wrong site" do
    validate_github_url("http://githap.com/puradawid/github_stats") do |model|
      model.errors[].expects("<<").once
    end
  end

  test "right url but without schema" do
    validate_github_url("github.com/puradawid/github_stats") do |model|
      model.errors[].expects("<<").once
    end
  end

  test "empty url" do
    validate_github_url("") do |model|
      model.errors[].expects("<<").never
    end
  end

  private

  def validate_github_url(url)
    model = generate_fake_model
    yield model, :github_url
    validator.validate_each(model,
                            :github_url,
                            url,
                            GithubStub::GithubStub.new)
    model
  end
end
