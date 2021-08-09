require "oj"
require "singleton"

# c.f. https://qiita.com/tknzk/items/a392c3ad8b43e80f6b38
# Usage:
#   set :json_encoder, OjEncoder.instance
class OjEncoder
  include Singleton

  def initialize
    ::Oj.default_options = { mode: :compat }
  end

  def encode(value)
    ::Oj.dump(value)
  end
end

