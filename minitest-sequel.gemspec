# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "minitest/sequel/version"

Gem::Specification.new do |spec|
  spec.name          = "minitest-sequel"
  spec.version       = Minitest::Sequel::VERSION
  spec.authors       = ["Kematzy"]
  spec.email         = ["kematzy@gmail.com"]

  spec.summary       = "Minitest assertions to speed-up development and testing of Sequel database setups."
  spec.description   = "A collection of convenient assertions to enable faster DRY'er testing of Sequel database apps/gems."
  spec.homepage      = "https://github.com/kematzy/minitest-sequel"
  spec.license       = "MIT"

  # # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # # delete this section to allow pushing this gem to any host.
  # if spec.respond_to?(:metadata)
  #   spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  # else
  #   raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  # end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency 'minitest-rg'
  spec.add_runtime_dependency "minitest", "~> 5.7", ">= 5.7.0"
  spec.add_runtime_dependency "sequel", "~> 4.26"

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "sqlite3"
  spec.add_development_dependency "minitest-assert_errors"
  spec.add_development_dependency "minitest-hooks"
  spec.add_development_dependency "simplecov"
  spec.add_development_dependency "rubocop"
end
