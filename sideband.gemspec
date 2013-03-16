# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'sideband/version'

Gem::Specification.new do |gem|
  gem.name          = 'sideband'
  gem.version       = Sideband::VERSION
  gem.authors       = ['Mike Evans']
  gem.email         = ['mike@urlgonomics.com']
  gem.description   = %q{Run simple workers in a separate thread}
  gem.summary       = %q{Run simple workers in a separate thread}
  gem.homepage      = 'https://github.com/mje113/sideband'

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ['lib']
  
  gem.add_development_dependency 'rake'
  gem.add_development_dependency 'minitest', '~> 4.6.2'
end
