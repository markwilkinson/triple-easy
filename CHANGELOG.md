# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- Initial implementation of the `triplify` helper function.
- Automatic conversion of strings to `RDF::URI` or `RDF::Literal`.
- Smart datatype detection for `xsd:date`, `xsd:dateTime`, `xsd:float`, `xsd:integer`.
- Support for language-tagged literals (default: "en").
- Support for named graphs (quads) via the `context` parameter.
- Top-level `triplify` method and `TripleEasy.triplify` module method.

### Changed
- Improved object type detection logic.

## [0.1.0] - 2026-03-27

### Added
- First public release of the gem.