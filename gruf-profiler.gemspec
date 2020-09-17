# frozen_string_literal: true

# Copyright (c) 2017-present, BigCommerce Pty. Ltd. All rights reserved
#
# Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated
# documentation files (the "Software"), to deal in the Software without restriction, including without limitation the
# rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit
# persons to whom the Software is furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all copies or substantial portions of the
# Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE
# WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
# COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
# OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#
$:.push File.expand_path("../lib", __FILE__)
require 'gruf/profiler/version'

Gem::Specification.new do |spec|
  spec.name          = 'gruf-profiler'
  spec.version       = Gruf::Profiler::VERSION
  spec.authors       = ['Shaun McCormick']
  spec.email         = ['shaun.mccormick@bigcommerce.com']

  spec.summary       = %q{Plugin for profiling gruf-backed gRPC requests}
  spec.description   = %q{Adds memory reporting and rbtrace to gruf servers}
  spec.homepage      = 'https://github.com/bigcommerce/gruf-profiler'
  spec.license       = 'MIT'

  spec.files         = Dir['README.md', 'CHANGELOG.md', 'CODE_OF_CONDUCT.md', 'lib/**/*', 'gruf-profiler.gemspec']
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.11'
  spec.add_development_dependency 'rake', '>= 10.0'
  spec.add_development_dependency 'rspec', '>= 3.8'
  spec.add_development_dependency 'pry', '>= 0'

  spec.add_runtime_dependency 'stackprof', '>= 0'
  spec.add_runtime_dependency 'rbtrace', '>= 0'
  spec.add_runtime_dependency 'memory_profiler', '>= 0.9'
end
