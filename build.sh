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

webpack=$(false)
move=$(true)

while true
do
  case "$1" in
    -w|--webpack)
      webpack=$(true)
      shift
      ;;
    -m|--move)
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

if $webpack
then
  rm -rf public/webpack/foreman_patch/*

  cd ../foreman

  rake plugin:assets:precompile[foreman_patch] RAILS_ENV=production DATABASE_URL=nulldb://nohost --trace
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
  mv -v foreman_patch*.gem /mnt/h/
fi
