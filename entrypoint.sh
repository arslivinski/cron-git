#!/usr/bin/env sh

set -euo pipefail

CRONTAB="* * * * *"
REPOSITORY=""
DIRECTORY=""
CLONE_OPTS=""
PULL_OPTS=""

function usage() {
  echo "usage:"
  echo "    docker run [docker-options] arslivinski/cron-git [options] <repository>"
  echo
  echo "description:"
  echo "    A Docker image that clone and periodically pull a Git repository."
  echo
  echo "options:"
  echo "    --crontab, -c:"
  echo "        A crontab expression that defines the peridiocity of the repository pulling. Default \"* * * * *\"".
  echo "    --directory, -d:"
  echo "        The directory where the repository will be cloned. If not set, the last segment of the repository's URL will be used."
  echo "    --clone-opts:"
  echo "        Additional arguments to be used on git-clone."
  echo "    --pull-opts:"
  echo "        Additional arguments to be used on git-pull."
  echo "    --help, -h:"
  echo "        Print this text."
  echo "    <repository>"
  echo "        The repository's GIT URL."
}

OPTIONS="c:d:h"
LONGOPTIONS="crontab:,directory:,clone-opts:,pull-opts:,help"
PARSED=$(getopt -n "$0" -o "$OPTIONS" -l "$LONGOPTIONS" -- "$@")

eval set -- "$PARSED"

while true; do
  case "$1" in
    -c|--crontab)
      CRONTAB="$2"
      shift 2
      ;;
    -d|--directory)
      DIRECTORY="$2"
      shift 2
      ;;
    --clone-opts)
      CLONE_OPTS="$2"
      shift 2
      ;;
    --pull-opts)
      PULL_OPTS="$2"
      shift 2
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    --)
      shift
      break
      ;;
    *)
      >&2 echo "Error"
      exit 2
  esac
done

# Validate required arguments
if [[ $# -ne 1 ]]; then
  >&2 echo "A repository GIT URL is required."
  exit 3
else
  REPOSITORY="$1"
fi

# If the directory is not set, use the last segment of the repository's URL
if [ -z "$DIRECTORY" ]; then
  DIRECTORY="/$(echo "$REPOSITORY" | sed -E "s/^.*\/(.+)\.git$/\1/")"
fi

if [ -n "$CLONE_OPTS" ]; then
  git clone "$CLONE_OPTS" "$REPOSITORY" "$DIRECTORY"
else
  git clone "$REPOSITORY" "$DIRECTORY"
fi

if [ -n "$PULL_OPTS" ]; then
  echo "$CRONTAB cd $DIRECTORY && git pull $PULL_OPTS" | crontab -
else
  echo "$CRONTAB cd $DIRECTORY && git pull" | crontab -
fi

crond -f -L /dev/stdout & wait

