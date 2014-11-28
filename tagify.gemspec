# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'tagify/version'

Gem::Specification.new do |spec|
  spec.name          = "tagify"
  spec.version       = Tagify::VERSION
  spec.authors       = ["Azzurrio"]
  spec.email         = ["just.azzurri@gmail.com"]
  spec.summary       = %q{Switch multiple selection fields into tags with autocomplete.}
  spec.description   = %q{Switch multiple selection fields into tags with autocomplete.}
  spec.homepage      = "https://github.com/Azzurrio/tagify"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency 'jquery-rails', '~> 3.1'
  spec.add_runtime_dependency 'jquery-ui-rails', '~> 5.0'
  spec.add_runtime_dependency 'coffee-rails', '~> 4.0'

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec", "~> 3.1.0"
end
