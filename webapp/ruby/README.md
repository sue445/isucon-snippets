# Ruby実装のスニペット
## 脳死で書くGemfile
```ruby
git_source(:github) { |repo_name| "git@github.com:#{repo_name}" }
```

[isucon.gemfile](isucon.gemfile)

## 脳死で書くrequire
```ruby
# TODO: Sinatra app内で include SentryMethods する
require_relative "./config/sentry_methods"

# 必要に応じて使う
# require "mysql2-nested_hash_bind"
# require_relative "./config/hash_group_by_prefix"
# require_relative "./config/mysql_methods"
# require_relative "./config/oj_encoder"
# require_relative "./config/oj_to_json_patch"
# require_relative "./config/redis_methods"
# require_relative "./config/sidekiq"
# require_relative "./config/sidekiq_methods"

# TODO: 終了直前にコメントアウトする
require_relative "./config/enable_monitoring"

# NOTE: enable_monitoringでddtraceとdatadog_thread_tracerをrequireしてるのでenable_monitoringをrequireした後でrequireする必要がある
# require_relative "./config/thread_helper"
```

`class App < Sinatra::Base` 内に下記を追加

```ruby
include SentryMethods
# using Mysql2::NestedHashBind::QueryExtension
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
# PUMA_WORKERS=
```

## Dummy app
```bash
bundle install
cp .env.example .env
vi .env

bundle exec foreman s
```

open http://localhost:8000/
