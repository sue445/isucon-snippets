# ddtrace v0系用の設定とモンキーパッチ
require "datadog/statsd"
require "ddtrace"
require "ddtrace/profiling/preload"

Datadog.configure do |c|
  app_name = "isucon"

  # Global settings
  c.runtime_metrics.enabled = true
  c.service = app_name
  c.analytics_enabled = true
  c.profiling.enabled = true
  c.version = "1.0.3"

  # Tracing settings
  c.analytics.enabled = true
  c.tracer.partial_flush.enabled = true
  c.tracer enabled: true, env: ENV["RACK_ENV"], tags: { app: app_name }
  c.tracer.sampler.default_rate = 1.0

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

# NOTE: 書くのをよく忘れるのでファイルをrequireした時点で自動で適用されるようにする
class Sinatra::Base
  register Datadog::Contrib::Sinatra::Tracer
end

# DatadogにWorkerのクラス名を送信するためのモンキーパッチをSidekiq::Worker#performに仕込む
module DatadogSidekiqWorkerPatch
  def perform(*)
    trace = ::Datadog.tracer.active_trace
    trace.resource = self.class.to_s if trace

    super
  end
end
