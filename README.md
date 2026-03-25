# triple-easy
Make the most obvious decisions automatically when creating RDF Triples using Kellogg's RDF libraries

## What does it do?

You pass a subject, predicate, and object, graph-like object, and optional Literal datatype.  It adds the triple to the graph

## why "easy"?

- You can pass URI strings or RDF::Resource objects as S/P/O and it does the most obvious thing.
- In the Object position, for non-URI strings, it does some regexp matching to guess what Literal datatype it should be, and auto-creates that RDF Literal
- If you, for example, explicitly want "http://example.org" in the Object position to be a Literal (string), then you can override the auto-detect  (this is useful when facing a dct:identifier property, where the range is a string, even if the string is a URI!)

## What does it NOT do

- currently cannot deal with quads... stay tuned!

  
