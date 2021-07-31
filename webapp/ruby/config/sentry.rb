require "sentry-ruby"
require "systemu"

Sentry.init do |config|
  config.dsn = ENV["SENTRY_DSN"]

  # TODO: sentryを無効化する時はenabled_environmentsを空にする
  config.enabled_environments = %w[production]
end

module SentryMethods
  def with_sentry
    yield
  rescue => error
    Sentry.capture_exception(error)
    raise error
  end

  # 外部コマンドを実行し、失敗したら標準出力と標準エラーを付与してSentryに送信する
  #
  # @param command [String]
  #
  # @return コマンド実行時の標準出力
  #
  # @raise RuntimeError 外部コマンドが失敗した
  def system_with_sentry(command)
    status, stdout, stderr = systemu(command)

    unless status.success?
      Sentry.set_extras(
        stdout: stdout,
        stderr: stderr,
      )
      raise "`#{command}` is failed"
    end

    stdout
  end
end
