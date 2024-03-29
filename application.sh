#!/usr/bin/env zsh
local pids=( )

if [ -z $(command -v bower) ]; then
  echo "Missing bower."
  return 1
fi

if [ -z $(command -v python) ]; then
  echo "Missing python."
  return 1
fi

python server &
pids+=("$!")

cd application

if [ ! -d "${PWD}/bower_components" ]; then
  bower install
fi

npm run server
pids+=("$!")

trap "kill_pids" SIGINT

function kill_pids() {
  for pid in ${pids[@]}; do
    kill -TERM "${pid}"
  done
}

for pid in ${pids[@]}; do
  wait "${pid}"
done
