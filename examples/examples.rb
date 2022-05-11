# frozen_string_literal: true

MicroCMS.service_domain = ENV.fetch('YOUR_DOMAIN', nil)
MicroCMS.api_key = ENV.fetch('YOUR_API_KEY', nil)

endpoint = ENV.fetch('YOUR_ENDPOINT', nil)

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
