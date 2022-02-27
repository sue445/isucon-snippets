require "sidekiq"
# require_relative "../trend_update_worker"

require_relative "./enable_monitoring"

sidekiq_redis_url = "redis://#{ENV["REDIS_HOST"]}:6379/0"

Sidekiq.configure_server do |config|
  config.redis = { url: sidekiq_redis_url }

  # sidekiqがjobをチェックする間隔(デフォルトは30秒)
  # NOTE: sidekiq-cronを秒単位で実行したい場合はここを小さくする
  # Sidekiq.options[:poll_interval] = 2
end

Sidekiq.configure_client do |config|
  config.redis = { url: sidekiq_redis_url }
end

require "sidekiq-cron"
require "yaml"

schedule_file = "#{__dir__}/sidekiq-cron.yml"

if File.exist?(schedule_file) && Sidekiq.server?
  Sidekiq::Cron::Job.load_from_hash!(YAML.load_file(schedule_file))
end
