# shellcheck disable=SC2016
find lib -type f | entr -s 'kill -SIGUSR1 $(pgrep -f "[f]lutter_tool.*run")' &
$TERMINAL -c noswallow flutter run -d linux
