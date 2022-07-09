# ddtraceをrequireしてない場合にもDatadogThreadHelper.traceと同じインターフェースを提供するためのヘルパー

if defined?(Datadog) && defined?(DatadogThreadTracer)
  # ddtraceをrequireしてる場合にはdatadog_thread_tracerをそのまま使う
  require "datadog_thread_tracer"
  ThreadHelper = DatadogThreadTracer
  return
end

# ddtraceをrequireしていない場合にはdatadog_thread_tracerと同じインターフェースを提供したヘルパーを定義する
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

  def self.trace
    helper = ThreadHelper.new

    yield helper

    helper.join_threads
  end
end
