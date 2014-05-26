# coding: utf-8

Gem::Specification.new do |spec|
  spec.name          = "vagrant-provider"
  spec.version       = "0.0.1"
  spec.authors       = ["Glen Mailer"]
  spec.email         = ["glenjamin@gmail.com"]
  spec.description   = %q{Vagrant plugin for provider swapping}
  spec.summary       = %q{Vagrant plugin for provider swapping}
  spec.homepage      = "http://github.com/glenjamin/vagrant-provider"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
