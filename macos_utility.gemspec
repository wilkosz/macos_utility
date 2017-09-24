lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'macos_utility/version'

Gem::Specification.new do |spec|
  spec.name          = 'macos_utility'
  spec.version       = MacosUtility::VERSION
  spec.authors       = ['Joshua Wilkosz']
  spec.email         = ['joshua@wilkosz.com.au']
  spec.summary       = 'Mac OS Utility class'
  spec.description   = 'Provides basic functionality for Mac Operating System'
  spec.homepage      = 'http://rubygems.org/gems/macos_utility'
  spec.files         = [
      'lib/macos_utility.rb',
      'lib/macos_utility/version.rb',
      'lib/macos_utility/constants.rb',
      'lib/macos_utility/process_obj.rb',
      'test/test_macos_utility.rb'
  ]
  spec.require_paths = ['lib','lib/macos_utility']
  spec.license       = 'Nonstandard'
  spec.add_development_dependency 'bundler', '~> 1.14'
  spec.add_development_dependency 'rake', '~> 10.5'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'minitest', '~> 5.10'
  spec.add_dependency 'timeout', '0.0'
end
