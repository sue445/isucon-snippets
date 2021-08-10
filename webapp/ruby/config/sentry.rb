require "sentry-ruby"

Sentry.init do |config|
  config.dsn = ENV["SENTRY_DSN"]

  # TODO: sentryを無効化する時はenabled_environmentsを空にする
  config.enabled_environments = %w[production development]
end
