require "sinatra"
require "dotenv"

Dotenv.load

class App < Sinatra::Base
  get "/" do
    "It works"
  end
end
