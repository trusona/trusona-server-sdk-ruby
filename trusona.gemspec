# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'trusona/version'

Gem::Specification.new do |spec|
  spec.name          = 'trusona'
  spec.version       = Trusona::VERSION
  spec.authors       = ['Trusona']
  spec.email         = ['engineering@trusona.com']

  spec.summary       = 'Trusona REST API wrapper'
  spec.description   = 'Easily interact with the Trusona REST API'
  spec.homepage      = 'https://trusona.com'
  spec.license       = 'Apache-2.0'
  spec.cert_chain    = ['trusona.pub.pem']
  spec.signing_key   = 'trusona.key.pem' if $0 =~ /gem\z/

  spec.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'httparty', '~> 0.15'

  spec.metadata['yard.run'] = 'yri' # use "yard" to build full HTML docs.

  spec.add_development_dependency 'activesupport', '~> 6.0'
  spec.add_development_dependency 'bump', '~> 0.5'
  spec.add_development_dependency 'dotenv', '~> 2.2'
  spec.add_development_dependency 'guard', '~> 2.14'
  spec.add_development_dependency 'guard-rspec', '~> 4.7'
  spec.add_development_dependency 'guard-rubocop', '~> 1.3'
  spec.add_development_dependency 'guard-yard', '~> 2.2'
  spec.add_development_dependency 'rake', '~> 13.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'rspec-wait', '~> 0.0'
  spec.add_development_dependency 'rubocop', '~> 1.11.0'
  spec.add_development_dependency 'rubocop-performance', '~> 1.10.0'
  spec.add_development_dependency 'simplecov', '0.21.2'
  spec.add_development_dependency 'yard', '~> 0.9'
  spec.add_development_dependency 'webmock', '~> 3.5'
end
