# Blogspam

Checking comments for spam is no fun. Blogspam.net provides a great
service to check comments for spam and you can use it easily with Ruby
and/or Rails apps.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'blogspam'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install blogspam

## Usage

Basic usage of Blogspam is really easy:

```ruby
response = Blogspam.check_spam({
  agent:   user_agent, # "Mozilla/5.0 (iPad; U; CPU OS 3_2_1 like Mac OS X; en-us) AppleWebKit/531.21.10 (KHTML, like Gecko) Mobile/7B405"
  comment: body, # "First comment!"
  email:   email, # "test@example.com"
  ip:      ip_address, # "127.0.0.1"
  name:    name, # "Test User"
  site:    site, # "https://example.com"
})

repsonse
# => {"result":"SPAM", "reason":"Posting links listed in surbl.org", "blocker":"20-ip.js", "version":"2.0"}
# => {"result":"OK", "version":"2.0"}
```

We also provide a Rails concern that you can include in your model.
You'll need two columns `is_spam` and `spam_reason` on your model to
store the results.

```bash
rails g migration AddSpamToComments is_spam:boolean spam_reason:string
rails db:migrate
```

After you've added the columns, you can include Blogspam in your model:

```ruby
class Comment < ApplicationRecord
  include Blogspam::Concern

  def blogspam_args
    {
      agent:   user_agent,
      comment: body,
      email:   author_email,
      ip:      ip_address,
      name:    author_name,
      site:    "http://example.com",
    }
  end
end
```

Each comment will be updated `after_create` to check for spam.

You also have access to `clean` and `spam` scopes to filter out clean
and spam comments.

```ruby
Comment.clean # => only is_spam = false comments
Comment.spam # => only is_spam = true comments
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/excid3/blogspam. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Blogspam project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/excid3/blogspam/blob/master/CODE_OF_CONDUCT.md).
