require "sentry-ruby"

Sentry.init do |config|
  # TODO: sentryを無効化する時はenabled_environmentsを空にするかファイルをrequireするのをやめる
  config.enabled_environments = %w[production development]
end

# NOTE: 書くのをよく忘れるのでファイルをrequireした時点で自動でSentry::Rack::CaptureExceptionsが適用されるようにする
class Sinatra::Base
  use Sentry::Rack::CaptureExceptions
end
