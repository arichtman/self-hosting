
envup() {
  local file=$([ -z "$1" ] && echo ".env" || echo ".env.$1")

  if [ -f $file ]; then
    set -a
    export $(echo $(cat $file | sed 's/#.*//g'| xargs) | envsubst)
    set +a
  else
    echo "No $file file found" 1>&2
    return 1
  fi
}
