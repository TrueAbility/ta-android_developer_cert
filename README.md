# AndroidDeveloperCert

This is the ruby gem that interfaces between ta-web and Google's AAD test API. 

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'androiddevelopercert'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install androiddevelopercert

## Usage

The client registers exams to the API, this is the only action.
```ruby
    creds = JSON.parse(GCP_JSON_KEY)
    client = AndroidDeveloperCert::Client.new(creds)
    module_name = client.register(user.uid, user.email, "AAD", assessment.id, exam_language: exam_language)
    # module name is also the name of an AbilityScreenVariant in ta-web
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to https://username:password@gems.dustyjones.com/

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/Trueability/ta-android_developer_cert.

## Copyright and Ownership

© 2024 Trueability

All code in this repository is owned by Trueability and is provided under the terms of the MIT License. By contributing to this repository, you agree that your contributions will be licensed under the same license.
