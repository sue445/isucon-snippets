require "stackprof"

module StackprofMethods
  # sinatraのroutes単位でstackprofを仕込むためのヘルパメソッド。1ファイルにつき1分間のdump内容が記録される
  #
  # @param enabled [Boolean]
  # @yield
  def with_stackprof(enabled = true)
    unless enabled
      return yield
    end

    # NOTE: sinatra.routeは "GET /users/:id" のような形式なのでファイル書き出し用に名前を整形する
    normalized_route = request.env["sinatra.route"].gsub(%r([ /:]+), "-")

    # NOTE: 1分1ファイルにする
    timestamp = Time.now.strftime("%Y%m%d-%H%M")

    StackProf.run(mode: :cpu, interval: 1000, raw: true, out: "tmp/stackprof/stackprof-cpu-#{normalized_route}-#{timestamp}.dump") do
      return yield
    end
  end
end
