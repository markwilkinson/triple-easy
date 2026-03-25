# frozen_string_literal: true

# require_relative "tests"

Gem::Specification.new do |spec|
  spec.name = 'triple_easy'
  spec.version = 1
  spec.authors = ['Mark Wilkinson']
  spec.email = ['markw@illuminae.com']

  spec.summary = 'make rdf triples easily'
  spec.description = 'triplify.'
  spec.homepage = 'https://example.org'
  spec.license = 'MIT'
  spec.required_ruby_version = '>= 3.2.0'

  spec.metadata['allowed_push_host'] = 'https://rubygemsorg
  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/markwilkinson/triple-easy'
  spec.metadata['changelog_uri'] = 'https://github.com/markwilkinson/triple-easy/blob/master/CHANGELOG.md'
  spec.metadata['rubygems_mfa_required'] = 'true'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:test|spec|features)/|\.(?:git|travis|circleci)|appveyor)})
    end
  end
  spec.bindir = 'exe'
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  # spec.require_paths = []

  # Uncomment to register a new dependency of your gem
  # spec.add_dependency "example-gem", "~> 1.0"

  # For more information and examples about making a new gem, checkout our
  # guide at: https://bundler.io/guides/creating_gem.html
end
