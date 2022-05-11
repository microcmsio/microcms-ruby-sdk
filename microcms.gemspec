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

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']
end
