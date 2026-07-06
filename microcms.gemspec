# frozen_string_literal: true

require_relative 'lib/microcms/version'

Gem::Specification.new do |spec|
  spec.name          = 'microcms-ruby-sdk'
  spec.version       = MicroCMS::VERSION
  spec.authors       = ['microCMS']

  spec.summary       = 'microCMS Ruby SDK'
  spec.description   = 'microCMS Ruby SDK'
  spec.homepage      = 'https://github.com/microcmsio/microcms-ruby-sdk'
  spec.required_ruby_version = Gem::Requirement.new('>= 2.6.0')

  spec.metadata['homepage_uri']    = spec.homepage
  spec.metadata['source_code_uri'] = spec.homepage
  spec.metadata['changelog_uri']   = spec.homepage

  spec.metadata['rubygems_mfa_required'] = 'true'

  # `ruby -e "puts Gem::Specification.load('microcms.gemspec').files.sort"` で確認可能
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z lib LICENSE README.md microcms.gemspec`.split("\x0").reject(&:empty?)
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'ostruct'
end
