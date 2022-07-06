# サブスレッドのトレースをDatadogに送るためのヘルパー
class ThreadHelper
  def initialize
    @threads = []
    @thread_count = 0
  end

  # ブロック内をスレッドで実行する。ddtraceをrequireしてる場合はトレースも行う
  # @param trace_name [String]
  # @yield
  def start_thread(trace_name = nil)
    if defined? ::Datadog
      @thread_count += 1
      trace_name ||= "thread_#{@thread_count}"

      # c.f. https://github.com/DataDog/dd-trace-rb/issues/1460
      tracer = Datadog::Tracing.send(:tracer)
      context = tracer.provider.context
      @threads << Thread.new(trace_name, context) do |trace_name, context|
        tracer = Datadog::Tracing.send(:tracer)
        tracer.provider.context = context
        Datadog::Tracing.trace(trace_name) do
          yield
        end
      end
    else
      # ddtraceをrequireしていない場合はトレースを行わずスレッドを実行する
      @threads << Thread.new do
        yield
      end
    end
  end

  # スレッドが終了するまで待つ
  def join_threads
    @threads.each(&:join)
  end

  # @yield
  # @yieldparam [ThreadHelper]
  def self.within_threads
    helper = ThreadHelper.new

    yield helper

    helper.join_threads
  end
end
