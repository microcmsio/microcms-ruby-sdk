# microCMS Ruby SDK

[microCMS](https://document.microcms.io/) のRuby SDKです。

## 保守方針

このSDKの現在の保守レベルは `Maintenance` です。

詳細は[SDKの保守方針](https://document.microcms.io/manual/limitations#hc2b0bc6659)をご覧ください。

## チュートリアル

[公式チュートリアル](https://document.microcms.io/tutorial/ruby/ruby-top)をご覧ください。

## インストール

アプリケーションのGemfileに以下を追加します。

```ruby
gem 'microcms-ruby-sdk'
```

その後、以下を実行します。

    $ bundle install

または、以下のコマンドで直接インストールできます。

    $ gem install microcms-ruby-sdk

## 使い方

### インポート

```rb
require 'microcms'
```

### クライアントオブジェクトの作成

```rb
MicroCMS.service_domain = 'YOUR_DOMAIN'
MicroCMS.api_key = 'YOUR_API_KEY'
```

`YOUR_DOMAIN` にはサービスのサブドメイン名（`XXXX.microcms.io` の `XXXX` の部分）を指定してください。FQDNではありません。

### コンテンツ一覧の取得

```rb
puts MicroCMS.list('endpoint')
```

### パラメータを指定したコンテンツ一覧の取得

```rb
puts MicroCMS.list(
    'endpoint',
    {
        draft_key: "abcd",
        limit: 100,
        offset: 1,
        orders: ['updatedAt'],
        q: 'こんにちは',
        fields: %w[id title],
        ids: ['foo'],
        filters: 'publishedAt[greater_than]2021-01-01',
        depth: 1,
    },
)
```

### 単一コンテンツの取得

```rb
puts MicroCMS.get('endpoint', 'ruby')
```

### パラメータを指定した単一コンテンツの取得

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

### オブジェクト形式のコンテンツの取得

```rb
puts MicroCMS.get('endpoint')
```

### コンテンツの作成

```rb
puts MicroCMS.create('endpoint', { text: 'こんにちは、microcms-ruby-sdk！' })
```

### IDを指定したコンテンツの作成

```rb
puts MicroCMS.create(
    'endpoint',
    {
        id: 'my-content-id',
        text: 'こんにちは、microcms-ruby-sdk！',
    },
)
```

### 下書きコンテンツの作成

```rb
puts MicroCMS.create(
    'endpoint',
    {
        id: 'my-content-id',
        text: 'こんにちは、microcms-ruby-sdk！',
    },
    { status: 'draft' },
)
```

### コンテンツの更新

```rb
puts MicroCMS.update(
    'endpoint',
    {
        id: 'microcms-ruby-sdk',
        text: 'こんにちは、microcms-ruby-sdkのupdateメソッド！',
    },
)
```

### オブジェクト形式のコンテンツの更新

```rb
puts MicroCMS.update('endpoint', { text: 'こんにちは、microcms-ruby-sdkのupdateメソッド！' })
```

### コンテンツの削除

```rb
MicroCMS.delete('endpoint', 'microcms-ruby-sdk')
```

## 開発

リポジトリをチェックアウトした後、`bin/setup` を実行して依存関係をインストールしてください。`bin/console` を実行すると、対話形式で動作を確認できます。

このgemをローカル環境にインストールするには、`bundle exec rake install` を実行してください。新しいバージョンをリリースするには、`version.rb` のバージョン番号を更新してから `bundle exec rake release` を実行します。このコマンドはバージョンのgitタグを作成し、gitのコミットとタグをpushした後、`.gem` ファイルを[rubygems.org](https://rubygems.org)にpushします。

## コントリビュート

バグ報告やプルリクエストは、[GitHub](https://github.com/microcmsio/microcms-ruby-sdk)で受け付けています。
