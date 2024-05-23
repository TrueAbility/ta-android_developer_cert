# keep order
require "android_developer_cert/version"
require "android_developer_cert/configuration"
require "android_developer_cert/client"
require "android_developer_cert/authenticator"
require "android_developer_cert/error"

require "googleauth"
require "jwt"
require "rest-client"
require 'awesome_print'

module AndroidDeveloperCert
  class << self
    attr_writer :configuration
  end

  def self.configuration(initialization_opts = {})
    @configuration ||= Configuration.new(initialization_opts)
  end

  def self.configure(initialization_opts = {})
    config = configuration(initialization_opts)
    yield(config) if block_given?
  end
end
