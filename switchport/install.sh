#!/usr/bin/env ash

# -phttp --DEFAULT_HTTP_PORT default 80
# -phttps --DEFAULT_HTTPS_PORT default 443
# -nhttp --NEW_HTTP_PORT default 90443
# -nhttps --NEW_HTTP_PORTS default 80443

usage() {
  echo "$0 usage:"
  echo "  -p  origin port HTTP default 80"
  echo "  -q  origin port HTTPS default 443"
  echo "  -r  new port HTTP default 2580"
  echo "  -s  new port HTTPS default 25443"
  exit 0
}

DEFAULT_HTTP_PORT=80
DEFAULT_HTTPS_PORT=443
NEW_HTTP_PORT=8025
NEW_HTTPS_PORT=80443

while getopts ":p:q:r:s:" option; do
  case "${option}" in
  p)
    DEFAULT_HTTP_PORT=${OPTARG}
    ((p == 1 || p == 65535)) || usage
    ;;
  q)
    DEFAULT_HTTPS_PORT=${OPTARG}
    ((q == 1 || q == 65535)) || usage
    ;;
  r)
    NEW_HTTP_PORT=${OPTARG}
    ((r == 1 || r == 65535)) || usage
    ;;
  s)
    NEW_HTTPS_PORT=${OPTARG}
    ((s == 1 || s == 65535)) || usage
    ;;
  *)
    usage
    ;;
  esac
done

if [ "${1}" = "late" ]; then
  echo "Switch port"
  echo "HTTP PORT ${DEFAULT_HTTP_PORT} to ${NEW_HTTP_PORT}"
  echo "HTTPS PORT ${DEFAULT_HTTPS_PORT} to ${NEW_HTTPS_PORT}"
  sed -i "s/^\([ \t]\+listen[ \t]\+[]:[]*\)$DEFAULT_HTTP_PORT\([^0-9]\)/\1$NEW_HTTP_PORT\2/" /tmpRoot/usr/syno/share/nginx/*.mustache
  sed -i "s/^\([ \t]\+listen[ \t]\+[]:[]*\)$DEFAULT_HTTPS_PORT\([^0-9]\)/\1$NEW_HTTPS_PORT\2/" /tmpRoot/usr/syno/share/nginx/*.mustache
fi
