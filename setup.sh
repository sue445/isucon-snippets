#!/bin/bash -e

# スニペットリポジトリ内の必要なファイルだけをコピーするためのスクリプト
# Usage: ./setup.sh /path/to/isucon/dir

readonly TARGET_DIR=$1

if [ -z "${TARGET_DIR}" ]; then
  echo "TARGET_DIR is required"
  exit 1
fi

cp Rakefile ${TARGET_DIR}
cp -R infra ${TARGET_DIR}

if [ -e "${TARGET_DIR}/webapp/ruby" ]; then
  cp webapp/ruby/.rubocop.yml ${TARGET_DIR}/webapp/ruby
  cp -R webapp/ruby/config ${TARGET_DIR}/webapp/ruby
fi

if [ -e "${TARGET_DIR}/ruby" ]; then
  cp webapp/ruby/.rubocop.yml ${TARGET_DIR}/ruby
  cp -R webapp/ruby/config ${TARGET_DIR}/ruby
fi

echo "Copy to ${TARGET_DIR}"
