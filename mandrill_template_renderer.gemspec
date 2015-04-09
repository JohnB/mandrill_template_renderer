# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'mandrill_template_renderer/version'

Gem::Specification.new do |spec|
  spec.name          = "mandrill_template_renderer"
  spec.version       = MandrillTemplateRenderer::VERSION
  spec.authors       = ["John Baylor"]
  spec.email         = ["john.baylor@gmail.com"]
  spec.summary       = %q{Renders a Mandrill template to a string.}
  spec.description   = %q{Fills in the dynamic portions of a Mandrill template with data from a hash.}
  spec.homepage      = "https://johnb.github.io/"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
end
