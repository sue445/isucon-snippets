require "sinatra"
require "dotenv"

Dotenv.load

ENV["RACK_ENV"] = "development"

# NOTE: 無効化したい場合はコメントアウトする
require_relative "./config/sentry"

require_relative "./config/sentry_methods"

class App < Sinatra::Base
  get "/" do
    "It works"
  end

  get "/sentry_test" do
    raise "sentry test"
  end
end
