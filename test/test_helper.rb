$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
require "halunke"

# NB: Since both parser.rb and tokenizer.rb are generated and contain some mismatched indentations we want to ignore those warnings.
require "warning"
Warning.ignore(/warning: mismatched indentations/, File.expand_path("../../lib/halunke/parser.rb", __FILE__))
Warning.ignore(/warning: mismatched indentations/, File.expand_path("../../lib/halunke/tokenizer.rb", __FILE__))

require "minitest/autorun"
