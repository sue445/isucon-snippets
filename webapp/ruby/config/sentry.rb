require "sentry-ruby"

Sentry.init do |config|
  # TODO: sentryを無効化する時はenabled_environmentsを空にする
  config.enabled_environments = %w[production development]
end
