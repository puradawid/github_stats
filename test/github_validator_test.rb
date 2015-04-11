require 'test_helper'
require 'mocha/mini_test'
require 'byebug'

class GithubStatsValidatorTest < ActiveSupport::TestCase
  def validator
    #instance a validator using regular constructor
    @validator ||= GithubStats::GithubProjectsUrlValidator.new({attributes: {something: "irrelevant"}})
  end

  # testing check_github_url helping method

  def generate_fake_model url, attr_name
    record = mock('model')
    record.stubs(:errors).returns([])
    record.errors.stubs('[]').returns({})
    record.errors[].stubs('<<')
    record.stubs(:records).returns([])
    record.records.stubs('[]').returns([])
    return record
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
    validated_record = validate_github_url("https://github.com/puradawid/github_stats_notexisting") do |model, attr_name|
      model.errors[attr_name].expects '<<'
    end
  end

  test "validate right existing github repo" do
    validated_record = validate_github_url("https://github.com/puradawid/github_stats") {}
  end

  private
  def validate_github_url url
    model = generate_fake_model url, :github_url
    validator.validate_each(
        model,
        :github_url,
        url)
    yield model, :github_url
    model
  end

end