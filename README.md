# microCMS Ruby SDK

[microCMS](https://document.microcms.io/manual/api-request) Ruby SDK.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'microcms-ruby-sdk'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install microcms-ruby-sdk

## Usage

```rb
require 'microcms'

MicroCMS.service_domain = ENV['YOUR_DOMAIN']
MicroCMS.api_key = ENV['YOUR_API_KEY']

endpoint = ENV['YOUR_ENDPOINT']

puts MicroCMS.list(endpoint)

puts MicroCMS.list(endpoint, {
                     limit: 100,
                     offset: 1,
                     orders: ['updatedAt'],
                     q: 'Hello',
                     fields: %w[id title],
                     filters: 'publishedAt[greater_than]2021-01-01'
                   })

puts MicroCMS.get(endpoint, 'ruby')

puts MicroCMS.get(endpoint, 'ruby', { draft_key: 'abcdef1234' })

puts MicroCMS.create(endpoint, { text: 'Hello, microcms-ruby-sdk!' })

puts MicroCMS.create(endpoint, { id: 'microcms-ruby-sdk', text: 'Hello, microcms-ruby-sdk!' })

puts MicroCMS.create(endpoint, { text: 'Hello, microcms-ruby-sdk!' }, { status: 'draft' })

puts MicroCMS.update(endpoint, { id: 'microcms-ruby-sdk', text: 'Hello, microcms-ruby-sdk update method!' })

MicroCMS.delete(endpoint, 'microcms-ruby-sdk')
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/microcms.
