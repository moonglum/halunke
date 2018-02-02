
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "halunke/version"

Gem::Specification.new do |spec|
  spec.name          = "halunke"
  spec.version       = Halunke::VERSION
  spec.authors       = ["Lucas Dohmen"]
  spec.email         = ["lucas@dohmen.io"]

  spec.summary       = %q{The Halunke programming language}
  spec.description   = %q{A prototype for an OO language that embraces ideas like immutability and Lispyness}
  spec.homepage      = "https://github.com/moonglum/halunke"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.16.1"
  spec.add_development_dependency "rake", "~> 12.3.0"
  spec.add_development_dependency "minitest", "~> 5.11.3"
end
