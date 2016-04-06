#!/bin/bash
set -euo pipefail

# GRADLE Wrapper IMproved – execute gradlew from below the project root dir
#   Copyright (C) 2016 Lars Winderling

# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.


startDir="$(pwd)"
curPath="$startDir"
gradlew="${startDir}/gradlew"
tmpDir='/tmp/gradlewim'
tmpFile="${tmpDir}/offline"
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

if [[ ! -e "$tmpDir" ]]; then
  mkdir -p "$tmpDir"
fi

if [[ ! -e "$tmpFile" ]]; then
  touch "$tmpFile"
fi

workOffline=''
if [[ -n "$tmpFile" ]] && [[ "$(cat "$tmpFile")" = 'offline' ]]; then
  workOffline='--offline'
fi


case "${1:-}" in
  --go-offline) echo 'offline' > "$tmpFile"\
                && echo "[INFO] going offline" >&2 \
                && exit
    ;;
  --go-online) truncate -s 0 "$tmpFile" \
                && echo "[INFO] going online" >&2 \
                && exit
  ;;
  --is-online) [[ -z "$workOffline" ]] \
               && echo "[INFO] true" >&2 \
               || echo "[INFO] false" >&2 \
               ; exit
    ;;
  --is-offline) [[ -z "$workOffline" ]] \
                && echo "[INFO] false" >&2 \
                || echo "[INFO] true" >&2 \
                ; exit
    ;;
  *) :
esac

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
  cd "$curPath" && $gradlew $workOffline "$@"
else
  echo "[ERROR] not inside a gradle project incl. a wrapper" >&2
  exitStatus=1
fi

exit $exitStatus

# vim: set ft=sh
# vim: ft=sh
