require 'test_helper'
require 'mocha/mini_test'
require 'byebug'

class GithubStatsValidatorTest < ActiveSupport::TestCase
  #dummy stub for Github source
  class GithubStub
    def repos(*opts)
      repo = opts[0]
      raise Github::Error::NotFound.new({}) unless repo[:user] == "puradawid" and repo[:repo] == "github_stats"
      self
    end

    def commits()
      self
    end

    def all()
      self 
    end
  end
	
  def validator
    #instance a validator using regular constructor
    @validator ||= GithubProjectsUrlValidator.new({presence: false, attributes: {a: false}})
  end

  # testing check_github_url helping method

  def generate_fake_model url, attr_name
    record = mock('model')
    record.stubs('errors').returns([])
    record.errors.stubs('[]').returns({})
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
      model.errors.[].expects('<<').once
    end
  end

  test "validate right existing github repo" do
    validated_record = validate_github_url("https://github.com/puradawid/github_stats") do |model, attr_name|
      model.errors.[].expects('<<').never
    end
  end

  test "validate wrong url" do
    validated_record = validate_github_url("this is not a url at all") do |model, attr_name|
      model.errors.[].expects('<<').once
    end
  end

  test "validate url to wrong site" do
    validated_record = validate_github_url("http://githap.com/puradawid/github_stats") do |model, attr_name|
      model.errors[].expects('<<').once
    end
  end

  test "right url but without schema" do
    validated_record = validate_github_url("github.com/puradawid/github_stats") do |model, attr_name|
      model.errors[].expects('<<').once
    end
  end

  test "empty url" do
    validated_record = validate_github_url("") do |model, attr_name|
      model.errors[].expects('<<').never
    end
  end


  private
  def validate_github_url url
    model = generate_fake_model url, :github_url
    yield model, :github_url
    validator.validate_each(
        model,
        :github_url,
        url,
        github_source=GithubStub.new)
    model
  end

end
