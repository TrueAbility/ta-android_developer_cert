# coding: utf-8
class AndroidDeveloperCert::Client
  attr_accessor :config

  def initialize(config = AndroidDeveloperCert.configuration)
    @config = config
  end

  def configure
    yield config
  end

  def google_id
    return @google_id if @google_id && @valid
    @google_id = AndroidDeveloperCert::Authenticator.new(config).google_id
  end

  # { userId: “”, userEmail: “”, examType: “”, assessmentId: “”, assessmentVariantId: “”, examLanguage: "java" }
  # examType AAD, PAD
  # examLanguage JAVA, KOTLIN DEFAULT JAVA
  # returns variant Id
  def register(user_id, user_email, exam_type, assessment_id, exam_language="JAVA")
    url = config.base_url + "/users/v1/register"
    body = {
      userId: user_id,
      userEmail: user_email,
      examType: exam_type,
      assessmentId: assessment_id,
      examLanguage: exam_language,
    }

    begin
      RestClient.log = Rails.logger
      Rails.logger.warn("Andorid -- #{body.inspect}")
      Rails.logger.warn("Android -- URL #{url}")
      json = JSON.parse(RestClient.post(url, body.to_json, {
                                           content_type: "application/json",
                                           authorization: "Bearer #{google_id()}"
                                         }))

      json["variantName"]
    rescue RestClient::Exception => e
      Rails.logger.warn("Android -- Exception #{e} -- #{e.response}")
      json = JSON.parse(e.http_body) if e.http_body.present?
      raise AndroidDeveloperCert::Error.new(json["error"]["message"])
    end
  end

  def exam_build_status(assessment_id)
    url = config.base_url + "/exam/v1/build/#{assessment_id}"
    begin
      json = JSON.parse(RestClient.get(url, {
                                         content_type: "application/json",
                                         authorization: "Bearer #{google_id()}"
                                       }))
      json["complete"]
    rescue RestClient::Exception => e
      Rails.logger.warn("Android -- Exception #{e} -- #{e.response}")
      json = JSON.parse(e.http_body) if e.http_body.present?
      raise AndroidDeveloperCert::Error.new(json["error"]["message"])
    end
  end
end
