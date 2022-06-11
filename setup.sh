#!/bin/bash -e

# スニペットリポジトリ内の必要なファイルだけをコピーするためのスクリプト
# Usage: ./setup.sh /path/to/isucon/dir

readonly TARGET_DIR=$1

if [ -z "${TARGET_DIR}" ]; then
  echo "TARGET_DIR is required"
  exit 1
fi

set -x
cp Rakefile ${TARGET_DIR}
cp -R infra ${TARGET_DIR}
set +x

if [ -e "${TARGET_DIR}/webapp/ruby" ]; then
  set -x
  cp webapp/ruby/.rubocop.yml ${TARGET_DIR}/webapp/ruby
  cp -R webapp/ruby/config ${TARGET_DIR}/webapp/ruby
  set +x
fi

if [ -e "${TARGET_DIR}/ruby" ]; then
  set -x
  cp webapp/ruby/.rubocop.yml ${TARGET_DIR}/ruby
  cp -R webapp/ruby/config ${TARGET_DIR}/ruby
  set +x
fi

echo "Copy to ${TARGET_DIR}"
