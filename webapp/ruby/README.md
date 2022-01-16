# Ruby実装のスニペット
## 脳死で書くGemfile
```ruby
gem "ddtrace"
gem "oj"
gem "parallel"
gem "puma_worker_killer", require: false
gem "sentry-ruby"
gem "stackprof"

# 必要に応じて使う
# gem "newrelic_rpm"
# gem "connection_pool"
# gem "dalli"
# gem "redis"
# gem "sidekiq"
```

## 脳死で書くrequire
```ruby
# TODO: Sinatra app内で include SentryMethods する
require_relative "./config/sentry_methods"

# TODO: 終了直前にコメントアウトする
require_relative "./config/enable_monitoring"
```

## Dummy app
```bash
bundle install
cp .env.example .env
vi .env

bundle exec foreman s
```

open http://localhost:8000/
