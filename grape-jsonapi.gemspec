# Generated by EmCousin
# frozen_string_literal: true

require File.expand_path('lib/grape_jsonapi/version', __dir__)

Gem::Specification.new do |gem|
  gem.authors       = ['Emmanuel Cousin']
  gem.email         = ['emmanuel_cousin@hotmail.fr']
  gem.summary       = 'Use grape-jsonapi in grape'
  gem.description   = 'Provides a Formatter for the Grape API DSL to emit objects serialized with jsonapi-serializer.'
  gem.homepage      = 'https://github.com/EmCousin/grape-jsonapi'

  gem.executables   = `git ls-files -- bin/*`.split("\n").map { |f| File.basename(f) }
  gem.files         = `git ls-files`.split("\n")
  gem.name          = 'grape-jsonapi'
  gem.require_paths = ['lib']
  gem.version       = Grape::Jsonapi::VERSION
  gem.licenses      = ['MIT']

  gem.required_ruby_version = '>= 3.2.0'

  gem.add_dependency 'grape'
  gem.add_dependency 'jsonapi-serializer'

  gem.metadata['rubygems_mfa_required'] = 'true'
end
