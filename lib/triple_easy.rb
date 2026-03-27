require 'triple_easy/version'

module TripleEasy
  # Easy way to add RDF triples (or quads) to an RDF repository.
  #
  # This helper automatically converts strings into proper {RDF::URI} or
  # {RDF::Literal} objects with sensible datatype guessing (including
  # xsd:date and xsd:dateTime). It also supports language-tagged strings.
  #
  # NOTE:  you are responsible for sending the right kind of graphy-like object!
  # If you send a RDF::Graph, this is fine, but you CANNOT send context nodes.
  # If you want to use named graphs, you must send an RDF::Repository.
  # The code does not control for this, so... you have been warned!
  #
  # @example Basic usage (top-level)
  #   require 'triple_easy'
  #
  #   repo = RDF::Repository.new
  #
  #   triplify("http://example.org/alice",
  #            "http://xmlns.com/foaf/0.1/name",
  #            "Alice Smith",
  #            repo)
  #
  # @example With datatype, language, and named graph (quad)
  #   triplify("http://example.org/bob",
  #            "http://xmlns.com/foaf/0.1/name",
  #            "Bob Schmidt",
  #            repo,
  #            language: "de")   # German label
  #
  #   triplify("http://example.org/bob",
  #            "http://schema.org/birthDate",
  #            "1990-05-15",
  #            repo)             # auto-detects xsd:date
  #
  #   triplify("http://example.org/bob",
  #            "http://schema.org/lastLogin",
  #            "2025-03-27T09:15:00",
  #            repo)             # auto-detects xsd:dateTime
  #
  # @param s [String, RDF::URI, RDF::Node] Subject – usually a URI
  # @param p [String, RDF::URI] Predicate – must be a URI
  # @param o [String, RDF::URI, RDF::Literal, Numeric] Object – literal or URI
  # @param repo [RDF::Repository, RDF::Mutable] Repository to insert the statement into
  # @param datatype [RDF::URI, nil] Explicit datatype for the object (overrides auto-detection)
  # @param context [String, RDF::URI, nil] Optional named graph (turns the statement into a quad)
  # @param language [String, Symbol, nil] Language tag for string literals (default: "en")
  #
  # @return [Boolean] +true+ if the statement was inserted, +false+ if any
  #                   required argument (s, p, o, repo) was empty
  #
  # @raise [SystemExit] (via +abort+) if subject, predicate or context
  #                     cannot be converted to a valid URI
  #
  # @note When +datatype+ is supplied it takes precedence. Otherwise the
  #       method tries to auto-detect URI, xsd:date, xsd:dateTime, numeric
  #       types, and falls back to a language-tagged literal using the
  #       +language+ parameter (default: English).
  #
  # @see RDF::Statement
  # @see RDF::Literal
  # @see RDF::URI
  def triplify(s, p, o, repo, datatype: nil, context: nil, language: 'en')
    # warn "context #{context}"
    s = s.strip if s.instance_of?(String)
    p = p.strip if p.instance_of?(String)
    o = o.strip if o.instance_of?(String)

    return false if s.to_s.empty? || p.to_s.empty? || o.to_s.empty? || repo.to_s.empty?

    # Convert subject to URI if needed
    unless s.respond_to?(:uri)
      if s.to_s =~ %r{^\w+:/?/?[^\s]+}
        s = RDF::URI.new(s.to_s)
      else
        abort "Subject #{s} must be a URI-compatible thingy"
      end
    end

    # Convert predicate to URI if needed
    unless p.respond_to?(:uri)
      if p.to_s =~ %r{^\w+:/?/?[^\s]+}
        p = RDF::URI.new(p.to_s)
      else
        abort "Predicate #{p} must be a URI-compatible thingy"
      end
    end

    # Convert object with smart literal detection
    unless o.respond_to?(:uri?)
      o = if datatype
            RDF::Literal.new(o.to_s, datatype: datatype)
          elsif o.to_s =~ %r{\A\w+:/?/?\w[^\s]+}
            RDF::URI.new(o.to_s)
          # Detect xsd:dateTime (contains T + time)
          elsif o.to_s =~ /^\d{4}-[01]\d-[0-3]\dT[0-2]\d:[0-5]\d/
            RDF::Literal.new(o.to_s, datatype: RDF::XSD.dateTime)
          # Detect xsd:date (YYYY-MM-DD, but NOT followed by T)
          elsif o.to_s =~ /^\d{4}-[01]\d-[0-3]\d(?!T)/
            RDF::Literal.new(o.to_s, datatype: RDF::XSD.date)
          # Numeric types
          elsif o.to_s =~ /^[+-]?\d+\.\d+/ && o.to_s !~ /[^+\-\d.]/
            RDF::Literal.new(o.to_s, datatype: RDF::XSD.float)
          elsif o.to_s =~ /^[+-]?[0-9]+$/ && o.to_s !~ /[^+\-\d.]/
            RDF::Literal.new(o.to_s, datatype: RDF::XSD.integer)
          else
            RDF::Literal.new(o.to_s, language: language)
          end
    end

    # Build statement (triple or quad)
    if context
      unless context.respond_to?(:uri)
        if context.to_s =~ %r{^\w+:/?/?[^\s]+}
          context = RDF::URI.new(context.to_s)
        else
          abort "Context #{context} must be a URI-compatible thingy"
        end
      end

      triple = RDF::Statement.new(s, p, o, graph_name: context)
    else
      triple = RDF::Statement.new(s, p, o)
    end

    repo.insert(triple)
    true
  end

  module_function :triplify # Allows TripleEasy.triplify(...) as well
end

# Expose triplify at the top level (RuboCop-friendly)
Object.extend TripleEasy
