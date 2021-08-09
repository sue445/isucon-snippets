require "newrelic_rpm"
require "mysql2"

# https://github.com/shirokanezoo/isucon9f/commit/db8ef5934666fde3e23c17a04c4394b12a343110#diff-e90610944058d63767be863ddbd31bfd を魔改造
class NRMysql2Client < Mysql2::Client
  LOG_FILE = "/tmp/sql.log"

  def initialize(*args)
    @logger = Logger.new(LOG_FILE)
    super
  end

  # SQL文からテーブル名のみを抽出する。サブクエリやJOINなどで複数のテーブルが含まれる場合はカンマ区切りで連結して返す
  # @param sql [String]
  # @return [String]
  def self.parse_table(sql)
    # Remove `FOR UPDATE` in `SELECT`
    sql = sql.gsub(/FOR\s+UPDATE/i, "")

    tables = sql.scan(/(?:FROM|INTO|UPDATE|JOIN)\s+([^(]+?)[\s(]/i).
      map { |matched| matched[0].strip.gsub("`", "") }.reject(&:empty?).uniq

    return "other" if tables.empty?

    tables.sort_by(&:to_s).join(",")
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

# 下記をコピペしていい感じに切り替えられるようにする
# Mysql2Client = Mysql2::Client
# Mysql2Client = NRMysql2Client
