# coding: utf-8
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
module Gruf
  module Profiler
    class Hook < Gruf::Hooks::Base
      def setup
        require 'rbtrace'
        require 'memory_profiler'
      end

      def outer_around(call_signature, _request, _active_call, &block)
        report = MemoryProfiler.report do
          yield
        end
        Gruf.logger.info "gruf profile for #{service_key}.#{method_key(call_signature)}:\n#{report.pretty_print}"
      end

      private

      ##
      # @return [String]
      #
      def method_key(call_signature)
        "#{service_key}.#{call_signature.to_s.gsub('_without_intercept', '')}"
      end

      ##
      # @return [String]
      #
      def service_key
        service.class.name.underscore.gsub('/','.')
      end

      ##
      # @return [Hash]
      #
      def options
        @options.fetch(:profiler, {})
      end
    end
  end
end

