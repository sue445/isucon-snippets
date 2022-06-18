# sidekiqの設定
require "sidekiq"
# require_relative "../workers/dummy_worker"

# TODO: workerクラスをrequireした後にrequireすること
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
  schedule_config = YAML.load_file(schedule_file)
  if schedule_config
    Sidekiq::Cron::Job.load_from_hash!(schedule_config)
  end
end
