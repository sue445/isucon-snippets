# Appended by sue445/isucon-snippets

# profiling and monitoring
gem "ddtrace", ">= 1.0.0.beta1"
gem "dogstatsd-ruby"
gem "google-protobuf", "~> 3.0"
gem "sentry-ruby"

gem "oj"
gem "parallel"
gem "puma_worker_killer", require: false

group :development do
  gem "rubocop-isucon", github: "sue445/rubocop-isucon"
end

# 必要に応じて使う
# gem "connection_pool"
# gem "redis"
# gem "sidekiq"
# gem "sidekiq-cron"
