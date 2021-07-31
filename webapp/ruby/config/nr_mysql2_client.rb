require "newrelic_rpm"
require "mysql2"

# https://github.com/shirokanezoo/isucon9f/commit/db8ef5934666fde3e23c17a04c4394b12a343110#diff-e90610944058d63767be863ddbd31bfd を魔改造
class NRMysql2Client < Mysql2::Client
  LOG_FILE = "/tmp/sql.log"

  def initialize(*args)
    @logger = Logger.new(LOG_FILE)
    super
  end

  # SQL文からテーブル名のみを抽出する
  # @param sql [String]
  # @return [String]
  def self.parse_table(sql)
    # Remove `FOR UPDATE` in `SELECT`
    sql = sql.gsub(/FOR\s+UPDATE/i, "")

    sql[/(?:FROM|INTO|UPDATE)\s+([^(]+?)[\s(]/i, 1]&.strip&.gsub("`", "") || "other"
  end

  def self.with_newrelic(sql)
    callback = -> (result, metrics, elapsed) do
      NewRelic::Agent::Datastores.notice_sql(sql, metrics, elapsed)
    end
    op = sql[/^(select|insert|update|delete|begin|commit|rollback)/i] || 'other'

    table = parse_table(sql)

    NewRelic::Agent::Datastores.wrap('MySQL', op, table, callback) do
      yield
    end
  end

  def query(sql, *args)
    table = NRMysql2Client.parse_table(sql)
    @logger.info "[#{table}] #{sql}"

    NRMysql2Client.with_newrelic(sql) do
      super
    end
  end
end
