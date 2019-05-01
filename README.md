# gruf-profiler - Profiler for gruf

[![CircleCI](https://circleci.com/gh/bigcommerce/gruf-profiler/tree/master.svg?style=svg)](https://circleci.com/gh/bigcommerce/gruf-profiler/tree/master) [![Gem Version](https://badge.fury.io/rb/gruf-profiler.svg)](https://badge.fury.io/rb/gruf-profiler) [![Inline docs](http://inch-ci.org/github/bigcommerce/gruf-profiler.svg?branch=master)](http://inch-ci.org/github/bigcommerce/gruf-profiler)

Adds a profiler interceptor for [gruf](https://github.com/bigcommerce/gruf) 2.0.0 or later.

## Installation

```ruby
gem 'gruf-profiler'
```

Then in an initializer or before use, after loading gruf:

```ruby
require 'gruf/profiler'

Gruf.configure do |c|
  c.interceptors.use(Gruf::Profiler::Interceptor)
end
```

## Usage

gruf-profiler includes and requires the [rbtrace](https://github.com/tmm1/rbtrace/) 
and [memory_profiler](https://github.com/SamSaffron/memory_profiler) gems by default.
 
### rbtrace

rbtrace is automatically loaded for every gruf service. You can view the 
[README](https://github.com/tmm1/rbtrace/blob/master/README.md) for rbtrace for more information,
but the general idea is that you can run against a running gruf instance to see tracing 
information about a gruf server:

```bash
rbtrace -p <PID_OF_GRUF> --firehose
```

Other options for the rbtrace binary are detailed in the rbtrace documentation.

### Memory Profiler

[Memory Profiler](https://github.com/SamSaffron/memory_profiler) is a gem that allows you to get
a memory usage report of a block of Ruby code. gruf-profiler automatically wraps gruf service
requests with this and provides a report to the logger (at a default level of DEBUG).

You can adjust that log level to say, INFO, like so:

```ruby
Gruf.configure do |c|
  c.interceptors.use(Gruf::Profiler::Interceptor, log_level: :info)
end
```

## License

Copyright (c) 2017-present, BigCommerce Pty. Ltd. All rights reserved 

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated 
documentation files (the "Software"), to deal in the Software without restriction, including without limitation the 
rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit 
persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the 
Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE 
WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR 
COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR 
OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
