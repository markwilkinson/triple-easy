# frozen_string_literal: true

require 'spec_helper'
require 'rdf'

RSpec.describe 'triplify' do
  let(:repo) { RDF::Repository.new }

  # Make the top-level triplify method available inside all examples
  def triplify(...) = TripleEasy.triplify(...) # forwards to the module method

  describe 'top-level usage' do
    it 'adds a simple triple with string literal (default English)' do
      result = triplify('http://ex.org/s', 'http://ex.org/p', 'Hello world', repo)

      expect(result).to be true
      expect(repo.count).to eq 1

      statement = repo.statements.first
      expect(statement.subject).to be_a(RDF::URI)
      expect(statement.predicate).to be_a(RDF::URI)
      expect(statement.object).to be_a(RDF::Literal)
      expect(statement.object.value).to eq 'Hello world'
      expect(statement.object.language).to eq :en
    end

    it 'adds a triple with custom language tag' do
      triplify('http://ex.org/s', 'http://ex.org/p', 'Hallo Welt', repo, language: 'de')

      literal = repo.statements.first.object
      expect(literal.language).to eq :de
    end

    it 'auto-detects xsd:date' do
      triplify('http://ex.org/s', 'http://ex.org/birthDate', '1990-05-15', repo)

      expect(repo.statements.first.object.datatype).to eq RDF::XSD.date
    end

    it 'auto-detects xsd:dateTime' do
      triplify('http://ex.org/s', 'http://ex.org/event', '2025-03-27T10:15:30', repo)

      expect(repo.statements.first.object.datatype).to eq RDF::XSD.dateTime
    end

    it 'respects explicit datatype' do
      triplify('http://ex.org/s', 'http://ex.org/age', '42', repo, datatype: RDF::XSD.integer)

      expect(repo.statements.first.object.datatype).to eq RDF::XSD.integer
    end

    it 'creates a quad when context is provided' do
      triplify('http://ex.org/s', 'http://ex.org/p', 'o', repo, context: 'http://ex.org/graph')

      expect(repo.statements.first.graph_name).to eq RDF::URI('http://ex.org/graph')
    end

    it 'returns false when any required argument is empty' do
      expect(triplify('', 'http://ex.org/p', 'o', repo)).to be false
      expect(triplify('http://ex.org/s', '', 'o', repo)).to be false
      expect(triplify('http://ex.org/s', 'http://ex.org/p', '', repo)).to be false
      expect(triplify('http://ex.org/s', 'http://ex.org/p', 'o', '')).to be false
    end

    it 'aborts with SystemExit on invalid URI' do
      expect do
        triplify('not-a-uri', 'http://ex.org/p', 'o', repo)
      end.to raise_error(SystemExit)
    end
  end

  describe 'TripleEasy.triplify (module method)' do
    it 'works identically to the top-level version' do
      expect(TripleEasy.triplify('http://ex.org/s', 'http://ex.org/p', 'Test', repo)).to be true
    end
  end
end
