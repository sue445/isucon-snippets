# NewRelic, Sentry, stackprofの一括有効＆一括無効を1ファイルのみで行うためのファイル
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

  c.tracer.enabled = true
  c.analytics_enabled = true
  c.env = ENV["RACK_ENV"]
  c.service = app_name
  c.tags = { app: app_name }

  c.use :sinatra, service_name: app_name + "-sinatra"
  c.use :mysql2,  service_name: app_name + "-mysql2"
  c.use :http,    service_name: app_name + "-http", split_by_domain: true

  # c.use :redis, service_name: app_name + "-redis"
end

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
