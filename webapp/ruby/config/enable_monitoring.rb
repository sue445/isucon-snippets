# ddtrace, Sentryの一括有効＆一括無効を1ファイルのみで行うためのファイル
require "sentry-ruby"
require "sinatra"
require "ddtrace"
require "mysql2"

Sentry.init do |config|
  config.enabled_environments = %w[production development]
end

# NOTE: 書くのをよく忘れるのでファイルをrequireした時点で自動でSentry::Rack::CaptureExceptionsnaなどが適用されるようにする
class Sinatra::Base
  use Sentry::Rack::CaptureExceptions
end

if DDTrace::VERSION::MAJOR >= 1
  require_relative "./ddtrace_v1"
else
  require_relative "./ddtrace_v0"
end

::Mysql2::Client.prepend(DatadogMysql2RawQuerySenderPatch)

# Datadogに `POST /api/condition/:jia_isu_uuid` のようなsinatraで定義してるrouting名で送信するためのパッチ
module DatadogSinatraRouteingPathNamePatch
  def route_eval
    # NOTE: sinatraのrouting内で @datadog_route を設定することでDatadog上で表示する時のresource名を上書きすることができる
    # c.f. https://github.com/DataDog/dd-trace-rb/blob/v0.54.2/lib/ddtrace/contrib/sinatra/tracer.rb#L112
    @datadog_route = request.env["sinatra.route"].split(" ").last

    super
  end
end

::Sinatra::Base.prepend(DatadogSinatraRouteingPathNamePatch)

# Sidekiq::Workerをincludeした全workerクラスにモンキーパッチをあてる
# NOTE: Sidekiq::Workerがincludeされているかどうかを厳密に調べようとするとインスタンスを生成する必要があって遅くなるため、
#       Sidekiq::Workerをincludeした時に生成されるクラスメソッド(sidekiq_options)の存在をチェックしている
sidekiq_worker_classes = ObjectSpace.each_object(Class).select do |klass|
  klass.name&.end_with?("Worker") && klass.respond_to?(:sidekiq_options)
end

sidekiq_worker_classes.each do |worker_class|
  worker_class.prepend(DatadogSidekiqWorkerPatch)
end
