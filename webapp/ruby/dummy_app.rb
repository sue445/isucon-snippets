require "sinatra"
require "dotenv"
require "stackprof"

Dotenv.load

ENV["RACK_ENV"] = "development"

# NOTE: 無効化したい場合はコメントアウトする
require_relative "./config/sentry"

require_relative "./config/sentry_methods"
require_relative "./config/stackprof_methods"

class App < Sinatra::Base
  use StackProf::Middleware,
      mode: :cpu,
      interval: 1000,
      raw: true,
      save_every: 1,
      path: "tmp/stackprof/",
      # 特定のPATHのみstackprofを有効化する
      enabled: lambda { |env| env["REQUEST_METHOD"] == "GET" && env["PATH_INFO"].start_with?("/users/") }

  get "/" do
    "It works"
  end

  get "/sentry_test" do
    raise "sentry test"
  end

  get "/users/:id" do
    "user #{params[:id]}"
  end

  include StackprofMethods

  get "/articles/:id" do
    with_stackprof do
      "article #{params[:id]}"
    end
  end
end
