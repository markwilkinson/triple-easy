# frozen_string_literal: true

Gem::Specification.new do |spec|
  spec.name        = 'triple_easy'
  spec.version     = '0.1.0' # ← Use semantic versioning (not just "1")
  spec.authors     = ['Mark Wilkinson']
  spec.email       = ['markw@illuminae.com']

  spec.summary     = 'Make RDF triples easily with automatic URI and literal conversion'
  spec.description = 'A lightweight helper that makes inserting RDF triples (and quads) ' \
                     'very convenient. It automatically converts strings into proper ' \
                     'RDF::URI or RDF::Literal objects with sensible datatype guessing ' \
                     '(including xsd:date and xsd:dateTime) and supports language tags.'

  spec.homepage    = 'https://github.com/markwilkinson/triple-easy'
  spec.license     = 'MIT'

  spec.required_ruby_version = '>= 3.2.0'

  # Metadata for RubyGems / rubydoc.info
  spec.metadata = {
    'homepage_uri' => spec.homepage,
    'source_code_uri' => 'https://github.com/markwilkinson/triple-easy',
    'documentation_uri' => 'https://rubydoc.info/gems/triple_easy', # This helps with auto-generated docs visibility
    'changelog_uri' => 'https://github.com/markwilkinson/triple-easy/blob/main/CHANGELOG.md',
    'bug_tracker_uri' => 'https://github.com/markwilkinson/triple-easy/issues',
    'rubygems_mfa_required' => 'true',
    'allowed_push_host' => 'https://rubygems.org'
  }

  # Files included in the gem (standard and clean)
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject do |f|
      f == __FILE__ ||
        f.match(%r{\A(?:(?:test|spec|features)/|\.(?:git|github|rspec|rubocop|travis|circleci)|appveyor)})
    end
  end

  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  # Optional but recommended for better documentation generation
  spec.extra_rdoc_files = ['README.md', 'LICENSE', 'CHANGELOG.md']

  spec.rdoc_options = [
    '--title', 'TripleEasy - Easy RDF Triplification',
    '--main',  'README.md',
    '--line-numbers'
  ]

  # Dependencies
  # spec.add_dependency "rdf", "~> 3.0"   # Uncomment and adjust if you depend on the rdf gem
  spec.add_development_dependency 'rdf', '~> 3.0'
  spec.add_development_dependency 'rspec', '~> 3.13'
end
