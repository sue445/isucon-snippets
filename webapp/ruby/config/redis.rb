require "redis"
require "connection_pool"

$redis = ConnectionPool::Wrapper.new(size: 32, timeout: 3) { Redis.new(host: ENV["REDIS_HOST"]) }

module RedisMethods
  def with_redis(cache_key, marshal: false, enabled: true)
    unless enabled
      return yield
    end

    cached_response = $redis.get(cache_key)
    if cached_response
      if marshal
        return Marshal.load(cached_response)
      else
        return cached_response
      end
    end

    actual = yield

    if marshal
      $redis.set(cache_key, Marshal.dump(actual))
    else
      $redis.set(cache_key, actual)
    end

    actual
  end

  def clear_redis_all_keys
    $redis.flushall
  end
end
