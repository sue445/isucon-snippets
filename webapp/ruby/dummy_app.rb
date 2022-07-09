require "sinatra"
require "dotenv"
require "mysql2"

Dotenv.load

ENV["RACK_ENV"] = "development"

# NOTE: 無効化したい場合はコメントアウトする
# require_relative "./config/enable_monitoring"

require_relative "./config/sentry_methods"
require_relative "./config/thread_helper"

class App < Sinatra::Base
  include SentryMethods

  get "/" do
    "It works"
  end

  get "/sentry_test" do
    system_with_sentry("ls ssssss")
    raise "sentry test"
  end

  get "/api/users/:id" do
    "user #{params[:id]}"
  end
end
