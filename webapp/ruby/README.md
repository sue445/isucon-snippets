# Ruby実装のスニペット
## 脳死で書くGemfile
```ruby
git_source(:github) { |repo_name| "git@github.com:#{repo_name}" }
```

[isucon.gemfile](isucon.gemfile)

## 脳死で書くrequire
```ruby
require "mysql2-nested_hash_bind"

# TODO: Sinatra app内で include SentryMethods する
require_relative "./config/sentry_methods"

# TODO: 終了直前にコメントアウトする
require_relative "./config/enable_monitoring"

class App < Sinatra::Base
  # Add this
  include SentryMethods
  using Mysql2::NestedHashBind::QueryExtension
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
