# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'dutch_uncle/version'

Gem::Specification.new do |spec|
  spec.name          = "dutch_uncle"
  spec.version       = DutchUncle::VERSION
  spec.authors       = ["Topper Bowers", "Chris Voxland"]
  spec.email         = ["topper@amicushq.com", "chris@amicushq.com"]
  spec.summary       = %q{DutchUncle is watching}
  spec.description   = %q{App monitoring and notification for influxdb and honeybadger.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "influxdb", '>= 0.1.5'
  spec.add_runtime_dependency "honeybadger"
  spec.add_runtime_dependency "commander"

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "guard-rspec"
  spec.add_development_dependency "pry"
end
