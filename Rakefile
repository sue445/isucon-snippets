# Requirements
# * ruby
# * curl
# * gh
#   * https://github.com/cli/cli
#   * gh auth login
#
# Usage
# * rake

# デプロイ先のサーバ
HOSTS = {
  ap: "",
  # db: "",
}

INITIALIZE_ENDPOINT = "http://#{HOSTS[:ap]}/initialize"

# デプロイ先のカレントディレクトリ
CURRENT_DIR = "/home/isucon/isutrain"

# デプロイを記録するissue
GITHUB_REPO     = "sue445/isuconXX-qualify"
GITHUB_ISSUE_ID = 1

BUNDLE = "/home/isucon/local/ruby/bin/bundle"

def exec(ip_address, command, cwd: CURRENT_DIR)
  sh %Q(ssh isucon@#{ip_address} 'cd #{cwd} && #{command}')
end

namespace :deploy do
  HOSTS.each do |name, ip_address|
    desc "Deploy to #{name}"
    task name do
      puts "[deploy:#{name}] START"

      # common
      exec ip_address, "git pull --ff"
      exec ip_address, "sudo systemctl daemon-reload"

      # TODO: 終了10分前にdisableすること！！！！！！
      exec ip_address, "sudo systemctl restart newrelic-infra"
      # exec ip_address, "sudo systemctl disable newrelic-infra"
      # exec ip_address, "sudo systemctl stop newrelic-infra"
      # exec ip_address, "sudo systemctl enable newrelic-infra"
      # exec ip_address, "sudo systemctl start newrelic-infra"

      case name
      when :ap
        # nginx
        # exec ip_address, "sudo nginx -t"
        # exec ip_address, "sudo systemctl restart nginx"

        # app
        # exec ip_address, "#{BUNDLE} install --path vendor/bundle --jobs $(nproc)", cwd: "#{CURRENT_DIR}/webapp/ruby"
        # exec ip_address, "sudo systemctl stop isutrain-ruby.service"
        # exec ip_address, "sudo systemctl start isutrain-ruby.service"
        # exec ip_address, "sudo systemctl status isutrain-ruby.service"

      when :db
        # mysql
        # exec ip_address, "sudo cp infra/mysql/mysqld.cnf /etc/mysql/mysql.conf.d/mysqld.cnf"
        # exec ip_address, "sudo mysqld --verbose --help > /dev/null"
        # exec ip_address, "sudo systemctl restart mysql"

        # memcached
        # exec ip_address, "sudo cp infra/memcached/memcached.conf /etc/memcached.conf"
        # exec ip_address, "sudo systemctl restart memcached"

        # redis
        # exec ip_address, "sudo cp infra/redis/redis.conf /etc/redis/redis.conf"
        # exec ip_address, "sudo systemctl restart redis"

        # sidekiq
        # exec ip_address, "#{BUNDLE} install --path vendor/bundle --jobs $(nproc)", cwd: "#{CURRENT_DIR}/webapp/ruby"
        # exec ip_address, "sudo systemctl stop isutrain-sidekiq.service"
        # exec ip_address, "sudo systemctl start isutrain-sidekiq.service"
        # exec ip_address, "sudo systemctl status isutrain-sidekiq.service"

        # payment
        # exec ip_address, "docker-compose -f webapp/docker-compose.yml -f webapp/docker-compose.ruby.yml down"
        # exec ip_address, "docker-compose -f webapp/docker-compose.yml up -d --build"
      end

      puts "[deploy:#{name}] END"
    end
  end
end

desc "Prepare for deploy"
task :setup do
  # push前のhashを取得しといて後で使う
  @before_revision = `git rev-parse --short origin/HEAD`.strip

  sh "git push"
end

desc "Deploy to all hosts"
multitask :deploy => HOSTS.keys.map { |name| "deploy:#{name}" }

desc "POST /initialize"
task :initialize do
  sh "curl -X POST --retry 3 --fail #{INITIALIZE_ENDPOINT}"
end

desc "Record current commit to issue"
task :record do
  revision = `git rev-parse --short HEAD`.strip
  message = ":rocket: Deployed #{revision} ([compare](https://github.com/#{GITHUB_REPO}/compare/#{@before_revision}...#{revision}))"

  sh "gh issue comment --repo #{GITHUB_REPO} #{GITHUB_ISSUE_ID} --body '#{message}'"
end

task :all => [:setup, :deploy, :initialize, :record]

task :default => :all