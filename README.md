# microCMS Ruby SDK

[microCMS](https://document.microcms.io/manual/api-request) Ruby SDK.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'microcms'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install microcms

## Usage

```rb
client = MicroCMS::Client.new(ENV["YOUR_DOMAIN"], ENV["YOUR_API_KEY"])
endpoint = ENV["YOUR_ENDPOINT"]

puts client.list(endpoint)

puts client.list(endpoint, {
  limit:  100,
  offset: 1,
  orders: ["updatedAt"],
  q:      "Hello",
  fields: ["id", "title"],
  filters:"publishedAt[greater_than]2021-01-01",
})

puts client.get(endpoint, "ruby")

puts client.get(endpoint, "ruby", { draft_key: "abcdef1234" })

puts client.create(endpoint, { text: "Hello, microcms-ruby-sdk!" })

puts client.create(endpoint, { id: "microcms-ruby-sdk", text: "Hello, microcms-ruby-sdk!" })

puts client.create(endpoint, { text: "Hello, microcms-ruby-sdk!" }, { status: "draft" })

puts client.update(endpoint, { id: "microcms-ruby-sdk", text: "Hello, microcms-ruby-sdk update method!" })

puts client.delete(endpoint, "microcms-ruby-sdk")
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/microcms.
