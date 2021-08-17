require "redis"
require "connection_pool"

$redis = ConnectionPool::Wrapper.new(size: 32, timeout: 3) { Redis.new(host: ENV["REDIS_HOST"]) }

module RedisMethods
  def with_redis(cache_key, enabled: true)
    unless enabled
      return yield
    end

    cached_response = $redis.get(cache_key)
    return cached_response if cached_response

    actual = yield

    $redis.set(cache_key, actual)

    actual
  end

  def clear_redis_all_keys
    $redis.flushall
  end
end
