require "dalli"
require "connection_pool"

$memcached = ConnectionPool.new(size: 32, timeout: 5) { Dalli::Client.new("#{ENV["MEMCACHED_HOST"]}:11211", compress: true) }

module MemcachedMethods
  def with_memcached(cache_key, enabled: true)
    unless enabled
      return yield
    end

    $memcached.with do |conn|
      cached_response = conn.get(cache_key)
      return cached_response if cached_response

      actual = yield

      conn.set(cache_key, actual)

      actual
    end
  end
end
