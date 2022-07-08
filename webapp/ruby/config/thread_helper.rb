# サブスレッドのトレースをDatadogに送るためのヘルパー
require "datadog_thread_tracer"

class ThreadHelper
  def initialize
    @threads = []
  end

  def trace(_trace_name = nil)
    @threads << Thread.new do
      yield
    end
  end

  def join_threads
    @threads.each(&:join)
  end

  def self.within_threads
    if defined? ::Datadog
      DatadogThreadTracer.trace do |thread_tracer|
        yield thread_tracer
      end
    else
      helper = ThreadHelper.new

      yield helper

      helper.join_threads
    end
  end
end
