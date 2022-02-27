# ddtrace, Sentry, stackprofの一括有効＆一括無効を1ファイルのみで行うためのファイル
require "sentry-ruby"
require "stackprof"
require "sinatra"
require "ddtrace"

Sentry.init do |config|
  config.enabled_environments = %w[production development]
end

def enabled_stackprof_path?(env)
  return true

  # TODO: 個別指定の場合はsave_everyを小さくしないとdumpが保存されないので一緒に変更すること
  case env["REQUEST_METHOD"]
  when "GET"
    # case env["PATH_INFO"]
    # when %r{^/users/[0-9]+$}
    #   return true
    # end

  when "POST"
    # case env["PATH_INFO"]
    # when "/message"
    #   return true
    # end

  end

  false
end

# NOTE: 書くのをよく忘れるのでファイルをrequireした時点で自動でSentry::Rack::CaptureExceptionsnaなどが適用されるようにする
class Sinatra::Base
  use Sentry::Rack::CaptureExceptions

  use StackProf::Middleware,
      mode: :cpu,
      interval: 1000,
      raw: true,
      save_every: 100,
      path: "tmp/stackprof/",
      # 特定のPATHのみstackprofを有効化する
      enabled: -> (env) { enabled_stackprof_path?(env) }
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
