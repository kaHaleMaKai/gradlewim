#!/bin/bash
set -euo pipefail

startDir="$(pwd)"
curPath="$startDir"
gradlew="${startDir}/gradlew"
foundGradlew=0
exitStatus=0

resetWorkingDir() {
  local exitStatus=$?
  cd "$startDir"
  exit "$exitStatus"
}

trap \
  resetWorkingDir \
  SIGHUP SIGINT SIGTERM KILL EXIT

while [[ "$curPath" != '/' ]]; do
  if [[ -f "$gradlew" ]]; then
    foundGradlew=1
    break
  else
    curPath="$(dirname "$curPath")"
    gradlew="${curPath}/gradlew"
  fi
done
if [[ $foundGradlew -eq 1 ]]; then
  cd "$curPath" && $gradlew "$@"
else
  echo "[ERROR] not inside a gradle project incl. a wrapper" >&2
  exitStatus=1
fi

exit $exitStatus

# vim: set ft=sh
# vim: ft=sh
