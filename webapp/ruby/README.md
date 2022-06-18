# Ruby実装のスニペット
## 脳死で書くGemfile
```ruby
# profiling and monitoring
gem "ddtrace", ">= 1.0.0"
gem "sentry-ruby"

# FIXME: ruby 3.2.0-devでインストールできないのでコメントアウト
# https://rubygems.org/gems/google-protobuf/versions/3.21.1-x86-linux
# gem "dogstatsd-ruby"
# gem "google-protobuf", "~> 3.0"

gem "oj"
gem "parallel"

group :development do
  gem "rubocop-isucon", github: "sue445/rubocop-isucon", require: false
  gem "rubocop_auto_corrector", require: false
end

# 必要に応じて使う
# gem "connection_pool"
# gem "puma_worker_killer", require: false
# gem "redis"
# gem "sidekiq"
# gem "sidekiq-cron"
```

## 脳死で書くrequire
```ruby
# TODO: Sinatra app内で include SentryMethods する
require_relative "./config/sentry_methods"

# TODO: 終了直前にコメントアウトする
require_relative "./config/enable_monitoring"

class App < Sinatra::Base
  # Add this
  include SentryMethods
```

## env.shに追加するやつ
`PUMA_PORT` は参照実装で使ってるport番号に変える

```
RUBYOPT="--yjit"
PUMA_PORT=
PUMA_THREADS_MIN=5
PUMA_THREADS_MAX=16
PUMA_LOGGING=false
PUMA_WORKER_KILLER=false
```

## Dummy app
```bash
bundle install
cp .env.example .env
vi .env

bundle exec foreman s
```

open http://localhost:8000/
