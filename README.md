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
MicroCMS.service_domain = "XXXX" # YOUR_DOMAIN is the XXXX part of XXXX.microcms.io
MicroCMS.api_key = "XXX"

puts MicroCMS.blog.list
puts MicroCMS.tag.list

puts MicroCMS.blog.list({
    draftKey: "foo",
    limit: 10,
    offset: 1,
    orders: ["createdAt", "-updatedAt"],
    q: "Ruby",
    fields: ["id", "title"],
    filters: "title[contains]microCMS",
    depth: 1,
})

puts MicroCMS.blog.get("my-content-id")

puts MicroCMS.blog.get("my-content-id", {
    draftKey: "foo",
    fields: ["id", "title"],
    depth: 1,
})

puts MicroCMS.blog.create({
    title: "Hello, microCMS!",
    contents: "Awesome contents...",
})

puts MicroCMS.blog.create({
    id: "my-content-id"
    title: "Hello, microCMS!",
    contents: "Awesome contents...",
})

puts MicroCMS.blog.update({
    id: "my-content-id",
    title: "Hello, microCMS Ruby SDK!",
})

puts MicroCMS.blog.delete("my-content-id")
```

You can use multiple instance.

```rb
client1 = MicroCMS::APIClient.new(
    "your-service-domain-1",
    "api-name-1",
    "api-key-1"
)
client2 = MicroCMS::APIClient.new(
    "your-service-domain-2",
    "api-name-2",
    "api-key-2"
)

puts client1.list
puts client2.list
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/microcms.
