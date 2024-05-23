class AndroidDeveloperCert::Authenticator
  attr_accessor :config, :signing_key
  private :signing_key

  def initialize(config)
    @config = config
    raise "No private key provided" if @config.private_key.nil?
    @signing_key = OpenSSL::PKey::RSA.new(config.private_key)
  end

  # get the gogole ID that is used as the Bearer token to access
  # the Android API, put this in an authorization header like so
  # "Authorization: Bearer #{token}"
  def google_id()
    begin
      params = {
        grant_type: config.grant_type,
        assertion: sign_payload()
      }
      form = URI.encode_www_form(params)
      response = RestClient.post(config.audience,
                                 form,
                                 {content_type: "application/x-www-form-urlencoded"}
                                )
      # This is a a working Google token ID you can verify it
      # at https://www.googleapis.com/oauth2/v3/tokeninfo?id_token={id_token}
      JSON.parse(response)['id_token']
    rescue RestClient::Exception => e
      raise "error getting token #{e} #{e&.response&.body}"
    end
  end

  private

  # the JWT payload that is needed to access the API, the token generated from this
  # payload is good for 1 hour. Maxinum values is 12 hours according to the iamcredentials docs.
  def payload
    now = Time.new
    {
      iat: now.to_i,
      exp: (now + 3600).to_i,
      iss: config.issuer,
      aud: config.audience,
      target_audience: config.target_audience,
    }
  end

  # The JWT error, only RS256 is accepted
  def header
    { typ: config.token_type, alg: config.signing_algorithm }
  end

  # base64 encode an object(s), returns an array of encoded objects
  # JWT consists of header.payload.signature, each part is
  # converted to json and base64 encoded (without the padding or newlines, hence the 'strict' encoding)
  # this method will accept an array of things to convert to json and encode
  def encode(to_encode)
    Array(to_encode).collect { |x| Base64.strict_encode64(x.to_json) }
  end

  # Step one of the process is to get a bearer token using our account
  # so that we can use the signing service to sign our payload
  # repeat this uses the credentials from TA's service account
  # the method seems to only take IO objects, so we putz around with stringIO
  def signing_token
    key_io = StringIO.new(config.json_key)
    authorizer = Google::Auth::ServiceAccountCredentials.make_creds(
      json_key_io: key_io,
      scope: config.scope)
    results = authorizer.fetch_access_token!
    results["access_token"]
  end

  # URL endpoint for signing blobs
  # https://cloud.google.com/iam/reference/rest/v1/projects.serviceAccounts/signBlob
  def blobSigningURL
    config.blob_signing_url.gsub('{{ISSUER}}', config.issuer)
  end


  # Step 2, sign the payload in order to access the Android API project
  # Once we get a JWT signature we can use our token, to get a google ID
  # that can be used to access the project, reminder the encoded bits of JWT
  # are base64 encoded and joined by a dot. RestClient raises an error when
  # the HTTP calls have a bad response
  def sign_payload
    begin
      assertion = encode([header, payload]).join('.') # encode the parts
      bytes_to_sign = Base64.strict_encode64(assertion) # encode the jwt as a whole
      body = { payload: bytes_to_sign }.to_json
      response = RestClient.post(blobSigningURL, body, {
                                   content_type: "application/json",
                                   authorization: "Bearer #{signing_token}"
                                 })
      signature = JSON.parse(response.body)["signedBlob"]
      [assertion, signature].join('.')
    rescue RestClient::Exception => e
      raise "error signing payload #{e} #{e&.response&.body}"
    end
  end
end
