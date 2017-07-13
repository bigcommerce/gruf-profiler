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
require 'spec_helper'
require 'pp'

class NullPrettyPrint < PP
  def pp_object(_)
  end
end

describe Gruf::Profiler::Hook do
  let(:service) { ThingService.new }
  let(:log_level) { :debug }
  let(:memory_profiler_options) { { pretty_print_options: { io: NullPrettyPrint.new } } }
  let(:options) { { log_level: log_level, memory_profiler: memory_profiler_options } }
  let(:signature) { 'get_thing' }
  let(:request) { grpc_request }
  let(:active_call) { grpc_active_call }
  let(:report) { double(:pretty_print)}
  let(:hook) { described_class.new(service, { profiler: options }) }

  before do
    hook.setup
  end

  describe '.outer_around' do
    let(:result) { rand(1..1000) }
    subject { hook.outer_around(signature, request, active_call) { result } }

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
