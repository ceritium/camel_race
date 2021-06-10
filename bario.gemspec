# frozen_string_literal: true

lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "bario/version"

Gem::Specification.new do |spec|
  spec.name          = "bario"
  spec.version       = Bario::VERSION
  spec.authors       = ["Jose Galisteo"]
  spec.email         = ["ceritium@gmail.com"]

  spec.summary       = "Redis based nested progress bars "
  spec.homepage      = "https://github.com/ceritium/bario"
  spec.license       = "MIT"

  spec.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "bin"
  spec.executables   = %w[bario-demo bario-web]
  spec.require_paths = ["lib"]

  spec.add_dependency "ohm", "~> 3.0"
  spec.add_dependency "sinatra", "2.0.8.1"
  spec.add_development_dependency "bundler"
  spec.add_development_dependency "codecov", "~> 0.1"
  spec.add_development_dependency "guard-rspec", "~> 4.7"
  spec.add_development_dependency "guard-rubocop", "~> 1.0"
  spec.add_development_dependency "rack-test", "~> 1.1"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "rubocop", "~> 0.51"
  spec.add_development_dependency "rubocop-rspec", "~> 2.4"
  spec.add_development_dependency "timecop", "~> 0.9"
end
