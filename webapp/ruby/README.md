# Ruby実装のスニペット
## 脳死で書くGemfile
```ruby
gem "newrelic_rpm"
gem "oj"
gem "parallel"
gem "sentry-ruby"
gem "stackprof"
gem "systemu"

# 必要に応じて使う
# gem "connection_pool"
# gem "dalli"
# gem "redis"
# gem "sidekiq"
```

## Dummy app
```bash
bundle install
cp .env.example .env
vi .env

bundle exec foreman s
```

open http://localhost:8000/
