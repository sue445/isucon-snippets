# Ruby実装のスニペット
## 脳死で書くGemfile
```ruby
# profiling and monitoring
gem "ddtrace", ">= 1.0.0.beta1"
gem "dogstatsd-ruby"
gem "google-protobuf", "~> 3.0"
gem "sentry-ruby"
gem "stackprof"

gem "oj"
gem "parallel"
gem "puma_worker_killer", require: false

group :development do
  gem "rubocop-isucon", github: "sue445/rubocop-isucon"
end

# 必要に応じて使う
# gem "connection_pool"
# gem "dalli"
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
```

## Dummy app
```bash
bundle install
cp .env.example .env
vi .env

bundle exec foreman s
```

open http://localhost:8000/
