# TripleEasy

**Make RDF triples (and quads) easily.**

`triple_easy` is a lightweight Ruby gem that provides a single convenient top-level function `triplify` to insert RDF statements into any `RDF::Repository` (or other mutable RDF store). It automatically converts plain strings into proper `RDF::URI` or `RDF::Literal` objects with sensible datatype guessing.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'triple_easy'
```

## why "easy"?

- You can pass URI strings or RDF::Resource objects as S/P/O and it does the most obvious thing.
- In the Object position, for non-URI strings, it does some regexp matching to guess what Literal datatype it should be, and auto-creates that RDF Literal
- If you, for example, explicitly want "http://example.org" in the Object position to be a Literal (string), then you can override the auto-detect  (this is useful when facing a dct:identifier property, where the range is a string, even if the string is a URI!)

## Examples of usage:

```
require 'triple_easy'

repo = RDF::Repository.new

# Basic triple
triplify("http://example.org/alice",
         "http://xmlns.com/foaf/0.1/name",
         "Alice Smith",  # string will default to language "en"
         repo)

# With language tag (non-English)
triplify("http://example.org/bob",
         "http://xmlns.com/foaf/0.1/name",
         "Bob Schmidt",
         repo,
         language: "de")

# With explicit datatype
triplify("http://example.org/charlie",
         "http://schema.org/age",
         "42",
         repo,
         datatype: RDF::XSD.integer)

# Date and DateTime auto-detection
triplify("http://example.org/diana",
         "http://schema.org/birthDate",
         "1995-06-15",          # → xsd:date
         repo)

triplify("http://example.org/diana",
         "http://schema.org/lastSeen",
         "2025-03-27T14:30:00", # → xsd:dateTime
         repo)

# Quad (with named graph / context)
triplify("http://example.org/eve",
         "http://xmlns.com/foaf/0.1/knows",
         "http://example.org/alice",
         repo,
         context: "http://example.org/my-graph")
         
```

## to use in your classes:

```
module Example
   class MyExample
      include TripleEasy     # bring "triplify" into this class
      def initialize
      end
   end
end

```

## Features

- Automatic URI detection for subjects, predicates, and objects
- Smart literal detection:
  - xsd:date and xsd:dateTime
  - xsd:float and xsd:integer
- Language-tagged strings (default: English)
- Optional explicit datatype (takes precedence)
- Support for named graphs (context)
- Returns true on success, false if any required argument is empty
- Raises helpful errors for invalid URIs

Full API documentation is available on rubydoc.info.

## Development
After checking out the repo, run bin/setup to install dependencies. Then, run bundle exec rspec to run the tests.

## Contributing
Bug reports and pull requests are welcome on GitHub at https://github.com/markwilkinson/triple-easy.

## License
The gem is available as open source under the terms of the MIT License.