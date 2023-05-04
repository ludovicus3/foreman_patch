#!/bin/bash
OPTIONS="wm"
LONGOPTIONS="webpack,move"

function usage {
  echo "$(basename $0) -h --> shows usage"
}

if ! options=$(getopt --options ${OPTIONS} --longoptions ${LONGOPTIONS} --name "$0" -- "$@")
then
  exit 1
fi

set -- $options

webpack=false
move=false

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

find ./app -name '*.rb' -exec ruby -wc {} >/dev/null \;

export FOREMAN_APIPIE_LANGS=en
export RAILS_ENV=${RAILS_ENV:-production}
export DATABASE_URL=nulldb://nohost

if $webpack
then
  rm -rf public/webpack/foreman_patch/*

  cd ../foreman

  rake plugin:assets:precompile[foreman_patch] --trace
  if [ $? -ne 0 ]; then
    cd ../foreman_patch
    echo "Build failed..." 1>&2
    exit 1
  fi

  cd ../foreman_patch
fi

gem build foreman_patch.gemspec
  
if $move
then
  mv -v foreman_patch*.gem /mnt/h/foreman_patch/
fi
