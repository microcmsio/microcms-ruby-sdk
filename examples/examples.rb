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
