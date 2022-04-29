# PenList

Pen testers use similar attacks across applications. Rack-attack can be used to thwart the attackers,
but then you must keep your configuration up-to-date across all apps you build.
This gem allows a common configuration for all rails apps.  

For now, I'm testing this with several personal projects. If you find it useful, feel free to use as is, adapt, or
even contribute a PR to make it better for everyone.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'pen_list', git: 'https://github.com/tylercal/pen_list'
```

And then execute:

    $ bundle install

## Usage

PenList will create two default rack-attack rules, a safe list and a block list. You can overwrite either of the rules
by making your own rack-attack configurations with the same rule names

### Safe List `[Pen List] logged in users and defined paths are safe`
Looks to mark as safe
* Logged in users via the presence of `:user` or `:current_user_id` in the `session` object
* Requests that share a prefix with any defined routes
    ```ruby
    #routes.rb
    resources :users, :posts, :comments
    
    # will allow any requests that start with "/users", "/posts", "/comments"
    ```


### Block list `[Pen List] Fail2Ban for common pen testing requests`
Sets up a Fail2ban rule around non-rails things like
* Paths ending with unusual extensions like `.jsp`, `.exe`, `.txt`
* Paths including indicators of other languages and frameworks like, `php`, `wp-login`, `servlet`
* Any path starting with a `.` or `_`

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/tylercal/pen_list. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/[USERNAME]/pen_list/blob/master/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the PenList project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/pen_list/blob/master/CODE_OF_CONDUCT.md).
