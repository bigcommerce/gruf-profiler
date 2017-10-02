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
require 'spec_helper'

describe Gruf::Profiler::Interceptor do
  let(:service) { ThingService.new }
  let(:log_level) { :debug }
  let(:memory_profiler_options) { { pretty_print_options: { io: NullPrettyPrint.new } } }
  let(:active_call) { grpc_active_call }
  let(:report) { double(:pretty_print) }

  let(:request) do
    double(
      :request,
      method_key: :get_thing,
      method_name: 'rpc.thing_service.get_thing',
      service: ThingService,
      rpc_desc: nil,
      active_call: active_call,
      message: grpc_message
    )
  end
  let(:options) { { log_level: log_level, memory_profiler: memory_profiler_options } }
  let(:errors) { Gruf::Error.new }
  let(:interceptor) { described_class.new(request, errors, options) }

  describe '.call' do
    let(:result) { rand(1..1000) }
    subject { interceptor.call { result } }

    before do
      allow(MemoryProfiler).to receive(:report).and_return(report)
    end

    it 'should generate the report and log it' do
      expect(MemoryProfiler).to receive(:report).once.and_call_original
      expect(Gruf.logger).to receive(log_level.to_sym).once
      expect(subject).to eq result
    end
  end
end
