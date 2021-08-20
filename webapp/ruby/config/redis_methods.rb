require "redis"
require "connection_pool"

$redis = ConnectionPool::Wrapper.new(size: 32, timeout: 3) { Redis.new(host: ENV["REDIS_HOST"]) }

module RedisMethods
  # redisにあればredisから取得し、キャッシュになければブロック内の処理で取得しredisに保存するメソッド（Rails.cache.fetchと同様のメソッド）
  #
  # @param cache_key [String]
  # @param enabled [Boolean] キャッシュを有効にするかどうか
  # @param marshal [Boolean] redisにMarshal.dumpで保存するかどうか(String以外はtrue必須)
  #
  # @yield キャッシュがなかった場合に実データを取得しにいくための処理
  # @yieldreturn [Object] redisに保存されるデータ
  #
  # @return [Object] redisに保存されるデータ
  def with_redis(cache_key, enabled: true, marshal: false)
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

    if actual
      if marshal
        $redis.set(cache_key, Marshal.dump(actual))
      else
        $redis.set(cache_key, actual)
      end
    end

    actual
  end

  def initialize_redis
    $redis.flushall
  end
end
