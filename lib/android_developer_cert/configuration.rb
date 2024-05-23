class AndroidDeveloperCert::Configuration
  AUDIENCE = 'https://www.googleapis.com/oauth2/v4/token'
  BASE_URL = 'https://record-dot-certification-assistant.appspot.com/_ah/api'
  ISSUER = 'service-record@certification-assistant.iam.gserviceaccount.com'
  BLOB_SIGNING_URL = "https://iamcredentials.googleapis.com/v1/projects/-/serviceAccounts/#{ISSUER}:signBlob"
  EXPIRY = 3600
  GRANT_TYPE = 'urn:ietf:params:oauth:grant-type:jwt-bearer'
  PROJECT_NAME = 'certification-assistant'
  SCOPE = 'https://www.googleapis.com/auth/iam'
  SIGNING_ALGORITHM = 'RS256'
  TARGET_AUDIENCE = 'service-record@certification-assistant.iam.gserviceaccount.com'
  TOKEN_TYPE = 'JWT'


  attr_accessor :audience,
                :auth_provider_x509_cert_url,
                :auth_uri,
                :base_url,
                :blob_signing_url,
                :client_email,
                :client_id,
                :client_x509_cert_url,
                :expiry,
                :grant_type,
                :issuer,
                :private_key,
                :private_key_id,
                :project_id,
                :project_name,
                :scope,
                :signing_algorithm,
                :signing_key,
                :target_audience,
                :token_type,
                :token_uri,
                :type

  DEFAULTS = {
    'audience' => AUDIENCE,
    'base_url' => BASE_URL,
    'blob_signing_url' => BLOB_SIGNING_URL,
    'expiry' => EXPIRY,
    'grant_type' => GRANT_TYPE,
    'issuer' => ISSUER,
    'project_name' => PROJECT_NAME,
    'scope' => SCOPE,
    'signing_algorithm' => SIGNING_ALGORITHM,
    'target_audience' => TARGET_AUDIENCE,
    'token_type' => TOKEN_TYPE,
  }

  def initialize(opts = {})
    opts = DEFAULTS.merge(opts)
    @audience = opts['audience']
    @auth_provider_x509_cert_url = opts['auth_provider_x590_cert_url']
    @auth_uri = opts['auth_uri']
    @base_url = opts['base_url']
    @blob_signing_url = opts['blob_signing_url']
    @client_email = opts['client_email']
    @client_id = opts['client_id']
    @client_x509_cert_url = opts['client_x509_cert_url']
    @expiry = opts['expiry']
    @grant_type = opts['grant_type']
    @issuer = opts['issuer']
    @private_key = opts['private_key']
    @private_key_id = opts['private_key_id']
    @project_id = opts['project_id']
    @project_name = opts['project_name']
    @scope = opts['scope']
    @signing_algorithm = SIGNING_ALGORITHM
    @signing_key = OpenSSL::PKey::RSA.new(@private_key) if @private_key
    @target_audience = opts['target_audience']
    @token_type = opts['token_type']
    @type = opts['type']
  end

  # recreate the Google JSON key format
  def json_key
    {
      type: type,
      project_id: project_id,
      private_key_id: private_key_id,
      private_key: private_key,
      client_email: client_email,
      client_id: client_id,
      auth_uri: auth_uri,
      token_uri: token_uri,
      auth_provider_x509_cert_url: auth_provider_x509_cert_url,
      client_x509_cert_url: client_x509_cert_url,
    }.to_json
  end


end
