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

Datadog.configure do |c|
  app_name = "isucon"

  c.tracer enabled: true, env: ENV["RACK_ENV"], tags: { app: app_name }
  c.service = app_name
  c.analytics_enabled = true

  c.use :sinatra, service_name: app_name + "-sinatra", analytics_enabled: true
  c.use :mysql2,  service_name: app_name + "-mysql2",  analytics_enabled: true
  c.use :http,    service_name: app_name + "-http",    analytics_enabled: true, split_by_domain: true

  # c.use :redis, service_name: app_name + "-redis", analytics_enabled: true
  # c.use :sidekiq, service_name: app_name + '-sidekiq', analytics_enabled: true, client_service_name: app_name + '-sidekiq-client'
end

# Datadog上だと生クエリが見れないため別tagとして送信するためのパッチ
module DatadogMysql2RawQuerySenderPatch
  def _query(sql, options = {})
    span = ::Datadog.tracer.active_span
    span.set_tag("sql.raw_query", sql) if span

    super(sql, options)
  end
end

::Mysql2::Client.prepend(DatadogMysql2RawQuerySenderPatch)

# NOTE: 書くのをよく忘れるのでファイルをrequireした時点で自動でSentry::Rack::CaptureExceptionsnaなどが適用されるようにする
class Sinatra::Base
  register Datadog::Contrib::Sinatra::Tracer

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
