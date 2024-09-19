#!/usr/bin/env ash

script_name=$(basename "$0")

usage() {
  echo "${script_name} usage:"
  echo "  -p  origin port HTTP default 80"
  echo "  -q  origin port HTTPS default 443"
  echo "  -r  new port HTTP default 2580"
  echo "  -s  new port HTTPS default 25443"
  exit 0
}

outrange() {
  echo "value $1 for param $2 out of range. Port number must be between 1 and 65535"
  usage
  exit 0
}

if [ "${1}" = "late" ]; then

  DEFAULT_HTTP_PORT=80
  DEFAULT_HTTPS_PORT=443
  NEW_HTTP_PORT=2580
  NEW_HTTPS_PORT=25443
  
  shift
  
  while getopts "p:q:r:s:" option; do
    case "${option}" in
    p)
      v=${OPTARG}
      (( $v >= 1 && $v <= 65535)) || outrange "$v" "${option}"
      DEFAULT_HTTP_PORT=$v
      ;;
    q)
      v=${OPTARG}
      (( $v >= 1 && $v <= 65535)) || outrange "$v" "${option}"
      DEFAULT_HTTPS_PORT=${OPTARG}
      ;;
    r)
      v=${OPTARG}
      (( $v >= 1 && $v <= 65535)) || outrange "$v" "${option}"
      NEW_HTTP_PORT=$v
      ;;
    s)
      v=${OPTARG}
      (( $v >= 1 && $v <= 65535)) || outrange "$v" "${option}"
      NEW_HTTPS_PORT=$v
      ;;
    *)
      usage
      ;;
    esac
  done
  
  echo "Switch port"
  echo "HTTP PORT ${DEFAULT_HTTP_PORT} to ${NEW_HTTP_PORT}"
  echo "HTTPS PORT ${DEFAULT_HTTPS_PORT} to ${NEW_HTTPS_PORT}"
  sed -i "s/^\([ \t]\+listen[ \t]\+[]:[]*\)$DEFAULT_HTTP_PORT\([^0-9]\)/\1$NEW_HTTP_PORT\2/" /tmpRoot/usr/syno/share/nginx/*.mustache
  sed -i "s/^\([ \t]\+listen[ \t]\+[]:[]*\)$DEFAULT_HTTPS_PORT\([^0-9]\)/\1$NEW_HTTPS_PORT\2/" /tmpRoot/usr/syno/share/nginx/*.mustache

fi
