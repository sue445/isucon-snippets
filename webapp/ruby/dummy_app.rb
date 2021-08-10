require "sinatra"
require "dotenv"

Dotenv.load

ENV["RACK_ENV"] = "development"

require_relative "./config/sentry"

class App < Sinatra::Base
  use Sentry::Rack::CaptureExceptions

  get "/" do
    "It works"
  end

  get "/sentry_test" do
    raise "sentry test"
  end
end
