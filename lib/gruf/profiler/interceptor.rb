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
require 'rbtrace'
require 'memory_profiler'

module Gruf
  module Profiler
    ##
    # Gruf hook that automatically loads rbtrace and memory profiler
    #
    # Add to your gruf initializer:
    #   require 'gruf/profiler'
    #   Gruf.configure do |c|
    #     c.interceptors[Gruf::Profiler::Interceptor] = {}
    #   end
    #
    class Interceptor < Gruf::Interceptors::ServerInterceptor
      ##
      # Wraps the entire gruf call and provides memory reports
      #
      def call
        result = nil
        report = MemoryProfiler.report(memory_profiler_options) do
          result = yield
        end
        if report
          profile(report)
        else
          log('Memory profiler did not return a report')
        end
        result
      end

      private

      ##
      # Profile the given report to logs
      #
      # @param [MemoryProfiler::Reporter] report
      #
      def profile(report)
        io_obj = pretty_print_options.fetch(:io, nil)
        report_string = io_obj ? report.pretty_print(io_obj, pretty_print_options) : report.pretty_print(pretty_print_options)
        log("gruf profile for #{request.method_name}:\n#{report_string}")
      end

      ##
      # Log a message with a configurable level to the gruf logger
      # @param [String]
      #
      def log(msg)
        level = options.fetch(:log_level, :debug).to_sym
        Gruf.logger.send(level, msg)
      end

      ##
      # Get sub-options for the memory profiler
      #
      # @return [Hash]
      #
      def memory_profiler_options
        options.fetch(:memory_profiler, top: 50)
      end

      ##
      # Get sub-options for pretty printing
      #
      # @return [Hash]
      #
      def pretty_print_options
        memory_profiler_options.fetch(:pretty_print_options, {})
      end
    end
  end
end
