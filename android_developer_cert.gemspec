
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "android_developer_cert/version"

Gem::Specification.new do |spec|
  spec.name          = "android_developer_cert"
  spec.version       = AndroidDeveloperCert::VERSION
  spec.authors       = ["Dusty Jones"]
  spec.email         = ["dusty@trueability.com"]

  spec.summary       = %q{Internal Gem to access AAD API}

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest", "~> 5.0"
  spec.add_dependency "awesome_print"
  spec.add_dependency "googleauth"
  spec.add_dependency "jwt"
  spec.add_dependency "rest-client"
end
