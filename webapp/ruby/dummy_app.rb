require "sinatra"
require "dotenv"
require "stackprof"

Dotenv.load

ENV["RACK_ENV"] = "development"

# NOTE: 無効化したい場合はコメントアウトする
require_relative "./config/sentry"

require_relative "./config/sentry_methods"
require_relative "./config/stackprof_methods"

def enabled_stackprof_path?(env)
  case env["REQUEST_METHOD"]
  when "GET"
    # case env["PATH_INFO"]
    # when %r{^/api/users/[0-9]+$}
    #   return true
    # end

  when "POST"
    # case env["PATH_INFO"]
    # when %r{^/api/users/[0-9]+$}
    #   return true
    # end
  end

  false
end

class App < Sinatra::Base
  use StackProf::Middleware,
      mode: :cpu,
      interval: 1000,
      raw: true,
      save_every: 1,
      path: "tmp/stackprof/",
      # 特定のPATHのみstackprofを有効化する
      enabled: -> (env) { enabled_stackprof_path?(env) }

  get "/" do
    "It works"
  end

  get "/sentry_test" do
    raise "sentry test"
  end

  get "/api/users/:id" do
    "user #{params[:id]}"
  end

  include StackprofMethods

  get "/api/articles/:id" do
    with_stackprof do
      "article #{params[:id]}"
    end
  end
end
