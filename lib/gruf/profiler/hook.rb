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

      ##
      # @param [Symbol] call_signature
      # @param [Object] _request
      # @param [GRPC::ActiveCall] _active_call
      #
      def outer_around(call_signature, _request, _active_call, &_block)
        result = nil
        report = MemoryProfiler.report(memory_profiler_options) do
          result = yield
        end
        if report
          pp_options = memory_profiler_options.fetch(:pretty_print_options, {})
          io_obj = pp_options.fetch(:io, nil)
          report_string = io_obj ? report.pretty_print(io_obj, pp_options) : report.pretty_print(pp_options)
          log("gruf profile for #{service_key}.#{method_key(call_signature)}:\n#{report_string}")
        else
          log('Memory profiler did not return a report')
        end
        result
      end

      private

      ##
      # @param [String]
      #
      def log(msg)
        level = options.fetch(:log_level, :debug).to_sym
        Gruf.logger.send(level, msg)
      end

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
        service.class.name.underscore.tr('/', '.')
      end

      ##
      # @return [Hash]
      #
      def options
        @options.fetch(:profiler, {})
      end

      ##
      # @return [Hash]
      #
      def memory_profiler_options
        options.fetch(:memory_profiler, top: 50)
      end
    end
  end
end
