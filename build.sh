#!/bin/bash
OPTIONS="wms"
LONGOPTIONS="webpack,move,syntax"

function find_foreman {
  path=$(pwd)
  while [[ "$path" != "" && ! -e "$path/foreman" ]]; do
    path=${path%/*}
  done
  echo "$path/foreman"
}

function usage {
  echo "$(basename $0) -h --> shows usage"
}

FOREMAN_PATCH_DIR=$(pwd)
FOREMAN_DIR=$(find_foreman)

echo "FOREMAN_DIR=${FOREMAN_DIR}"
echo "FOREMAN_PATCH_DIR=${FOREMAN_PATCH_DIR}"

if ! options=$(getopt --options ${OPTIONS} --longoptions ${LONGOPTIONS} --name "$0" -- "$@")
then
  exit 1
fi

set -- $options

webpack=false
move=false
ruby_syntax=false

while true
do
  case "$1" in
    -w|--webpack)
      webpack=true
      shift
      ;;
    -m|--move)
      move=true
      shift
      ;;
    -s|--syntax)
      syntax=true
      shift
      ;;
    --)
      shift
      break
      ;;
    *)
      echo "Not implemented: $1" >&2
      exit 1
      ;;
  esac
done

export FOREMAN_APIPIE_LANGS=en
export RAILS_ENV=${RAILS_ENV:-production}
export DATABASE_URL=nulldb://nohost

echo "RAILS_ENV=${RAILS_ENV}"

if $syntax
then
  find ./app -name '*.rb' -exec ruby -wc {} >/dev/null \;
fi

if $webpack
then
  rm -rf public/webpack/foreman_patch/*

  cd ${FOREMAN_DIR}

  bundle exec rake plugin:assets:precompile[foreman_patch] --trace
  if [ $? -ne 0 ]; then
    cd ${FOREMAN_PATCH_DIR}
    echo "Build failed..." 1>&2
    exit 1
  fi

  cd ${FOREMAN_PATCH_DIR}
fi

gem build foreman_patch.gemspec
