# encoding: utf-8

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'basehangul/version'

Gem::Specification.new do |spec|
  spec.name          = 'basehangul'
  spec.version       = BaseHangul::Version::STRING
  spec.authors       = ['ChaYoung You']
  spec.email         = %w(yousbe@gmail.com)
  spec.summary       = 'Human-readable binary encoding, BaseHangul for Ruby.'
  spec.description   = 'Human-readable binary encoding, BaseHangul for Ruby.'
  spec.homepage      = ''
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = %w(lib)

  spec.add_development_dependency 'bundler', '~> 1.7'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'rubocop', '~> 0.32.0'
  spec.add_development_dependency 'simplecov', '~> 0.9'
end
