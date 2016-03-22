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
