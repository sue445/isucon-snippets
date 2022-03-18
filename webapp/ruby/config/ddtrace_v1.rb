require "ddtrace"

Datadog.configure do |c|
  app_name = "isucon"

  # Global settings
  c.runtime_metrics.enabled = true
  c.service = app_name
  c.env = ENV["RACK_ENV"]
  c.tags = { app: app_name }

  # Tracing settings
  c.tracing.analytics.enabled = true
  c.tracing.partial_flush.enabled = true
  # c.tracing.sampler = Datadog::AllSampler.new

  # Instrumentation
  c.tracing.instrument :sinatra, service_name: app_name + "-sinatra", analytics_enabled: true
  c.tracing.instrument :mysql2,  service_name: app_name + "-mysql2",  analytics_enabled: true
  c.tracing.instrument :http,    service_name: app_name + "-http",    analytics_enabled: true, split_by_domain: true

  # c.tracing.instrument :redis, service_name: app_name + "-redis", analytics_enabled: true
  # c.tracing.instrument :sidekiq, service_name: app_name + '-sidekiq', analytics_enabled: true, client_service_name: app_name + '-sidekiq-client'
end

# Datadog上だと生クエリが見れないため別tagとして送信するためのパッチ
module DatadogMysql2RawQuerySenderPatch
  def _query(sql, options = {})
    span = ::Datadog::Tracing.active_span
    span.set_tag("sql.raw_query", sql) if span

    super(sql, options)
  end
end

# NOTE: 書くのをよく忘れるのでファイルをrequireした時点で自動で適用されるようにする
class Sinatra::Base
  register Datadog::Tracing::Contrib::Sinatra::Tracer
end


# Sidekiq::Worker#performにモンキーパッチを仕込む
module DatadogSidekiqWorkerPatch
  def perform(*)
    ::Datadog::Tracing.trace("sidekiq.perform", service: "isucon-sidekiq-worker", resource: self.class.to_s) do
      super
    end
  end
end
