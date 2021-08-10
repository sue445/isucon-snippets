# Gemfile
```ruby
gem "newrelic_rpm"
gem "oj"
gem "parallel"
gem "sentry-ruby"
gem "systemu"

# gem "connection_pool"
# gem "dalli"
# gem "redis"
# gem "sidekiq"
```

# env
```
RACK_ENV=production
MEMCACHED_HOST=172.31.xxx.xxx
```

## Dummy app
```bash
bundle install
cp .env.example .env
vi .env

bundle exec foreman s
```

open http://localhost:8000/
