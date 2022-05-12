# microCMS Ruby SDK

[microCMS](https://document.microcms.io/manual/api-request) Ruby SDK.

## Tutorial

See [official tutorial](https://document.microcms.io/tutorial/ruby/ruby-top).

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

### Import

```rb
require 'microcms'
```

### Create client object

```rb
MicroCMS.service_domain = 'YOUR_DOMAIN'
MicroCMS.api_key = 'YOUR_API_KEY'
```

### Get content list

```rb
puts MicroCMS.list('endpoint')
```

### Get content list with parameters

```rb
puts MicroCMS.list(
    'endpoint',
    {
        draft_key: "abcd",
        limit: 100,
        offset: 1,
        orders: ['updatedAt'],
        q: 'Hello',
        fields: %w[id title],
        ids: ['foo'],
        filters: 'publishedAt[greater_than]2021-01-01',
        depth: 1,
    },
)
```

### Get single content

```rb
puts MicroCMS.get('endpoint', 'ruby')
```

### Get single content with parameters

```rb
puts MicroCMS.get(
    'endpoint',
    'ruby',
    {
        draft_key: 'abcdef1234',
        fields: %w[title publishedAt],
        depth: 1,
    },
)
```

### Get object form content

```rb
puts MicroCMS.get('endpoint')
```

### Create content

```rb
puts MicroCMS.create('endpoint', { text: 'Hello, microcms-ruby-sdk!' })
```

### Create content with specified ID

```rb
puts MicroCMS.create(
    'endpoint',
    {
        id: 'my-content-id',
        text: 'Hello, microcms-ruby-sdk!',
    },
)
```

### Create draft content

```rb
puts MicroCMS.create(
    'endpoint',
    {
        id: 'my-content-id',
        text: 'Hello, microcms-ruby-sdk!',
    },
    { status: 'draft' },
)
```

### Update content

```rb

puts MicroCMS.update(
    'endpoint',
    {
        id: 'microcms-ruby-sdk',
        text: 'Hello, microcms-ruby-sdk update method!',
    },
)
```

### Update object form content

```rb
puts MicroCMS.update('endpoint', { text: 'Hello, microcms-ruby-sdk update method!' })
```

### Delete content

```rb
MicroCMS.delete('endpoint', 'microcms-ruby-sdk')
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at <https://github.com/microcmsio/microcms-ruby-sdk>.
