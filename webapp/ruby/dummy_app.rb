require "sinatra"
require "dotenv"

Dotenv.load

ENV["RACK_ENV"] = "development"

# NOTE: 無効化したい場合はコメントアウトする
require_relative "./config/sentry"

require_relative "./config/sentry_methods"
require_relative "./config/stackprof_methods"

class App < Sinatra::Base
  include StackprofMethods

  get "/" do
    "It works"
  end

  get "/sentry_test" do
    raise "sentry test"
  end

  get "/users/:id" do
    with_stackprof(true) do
      "user #{params[:id]}"
    end
  end
end
