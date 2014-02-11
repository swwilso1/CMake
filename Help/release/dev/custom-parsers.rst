custom-parsers
--------------

* Rewrite the cmMakefile::ExpandVariablesInString method to use a custom
  parser. This allows us to remove the lex/yacc parser for expanding
  variables.
* Optimize cmGeneratorExpression::StripEmptyListElements and
  cmSystemTools::ExpandListArguments so as not to build a string
  character-by-character. This avoids excess reallocations of the result
  string.
* Optimize cmGeneratorExpressionLexer::Tokenize to use a switch statement. The
  many dereferences of the input pointer were expensive. Also remove excess
  pointer arithmetic.
* Testing the configure (no generate) step with ParaView shows ~20%
  performance improvement (~47s -> ~39s on my machine).
* In terms of complete configure/generate steps, further testing with ParaView
  shows a 20% performance improvement over 2.8.12.2 with Unix Makefiles and
  minimal with Ninja. Ninja is less because it generate step is the expensive
  part (future work will address this) by a long shot and these changes help
  the configure step for the most part.
