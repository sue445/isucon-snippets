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

function copy_to_ruby_dir() {
  local ruby_dir=$1

  set -x
  cp webapp/ruby/.rubocop.yml ${ruby_dir}
  cp -R webapp/ruby/config ${ruby_dir}
  set +x
}

if [ -e "${TARGET_DIR}/webapp/ruby" ]; then
  copy_to_ruby_dir "${TARGET_DIR}/webapp/ruby"
fi

if [ -e "${TARGET_DIR}/ruby" ]; then
  copy_to_ruby_dir "${TARGET_DIR}/ruby"
fi

echo "Copy to ${TARGET_DIR}"
