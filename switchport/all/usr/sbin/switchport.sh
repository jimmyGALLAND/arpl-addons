#!/usr/bin/env ash

SCRIPT_NAME=$(basename "$0")
TARGET_DIR="/usr/syno/share/nginx"
TARGET_FILE="${TARGET_DIR}/*.mustache"
CURRENT_HTTP_PORT_FILE="${TARGET_DIR}/current_http_port"
CURRENT_HTTPS_PORT_FILE="${TARGET_DIR}/current_https_port"

usage() {
  echo "${script_name} usage:"
  echo " ${script_name} HTTP_PORT HTTPS_PORT"
  echo " requires two parameters or none"
  echo " with no parameter default HTTP_PORT 80 and HTTPS_PORT 443"
  echo " The port number must be between 1 and 65535"
  exit 0
}

is_number() {
  [ -n "$1" ] && [ "$1" -eq "$1" ] 2>/dev/null
  if [ $? -ne 0 ]; then
    return 0
  fi
  return 1
}

outrange() {
  if is_number $1; then
    echo "Port number \"$1\" not accepted. The port must be a number"
    usage
  fi

  if [ $1 -ge 1 ] && [ $1 -le 65535 ]; then
    return
  else
    echo "Port number \"$1\" not accepted. The port number must be between 1 and 65535"
    usage
  fi
}

CURRENT_HTTP_PORT=80
CURRENT_HTTPS_PORT=443

if [ -f "${CURRENT_HTTP_PORT_FILE}" ]; then
  CURRENT_HTTP_PORT=$(cat "${CURRENT_HTTP_PORT_FILE}")
fi

if [ -f "${CURRENT_HTTPS_PORT_FILE}" ]; then
  CURRENT_HTTPS_PORT=$(cat "${CURRENT_HTTPS_PORT_FILE}")
fi

if [ "$#" != "0" ] && [ "$#" != "2" ]; then usage; fi

if [ "$#" -eq "0" ]; then
  NEW_HTTP_PORT=${CURRENT_HTTP_PORT}
  NEW_HTTPS_PORT=${CURRENT_HTTPS_PORT}
fi

if [ "$#" -eq "2" ]; then
  NEW_HTTP_PORT=$1
  NEW_HTTPS_PORT=$2
fi

outrange "${NEW_HTTP_PORT}"
outrange "${NEW_HTTPS_PORT}"

if [ "${CURRENT_HTTP_PORT}" != "${NEW_HTTP_PORT}" ]; then
  sed -i "s/^\([ \t]\+listen[ \t]\+[]:[]*\)${CURRENT_HTTP_PORT}\([^0-9]\)/\1${NEW_HTTP_PORT}\2/" ${TARGET_FILE}
  echo ${NEW_HTTP_PORT} >"${CURRENT_HTTP_PORT_FILE}"
  echo "Switch port http ${CURRENT_HTTP_PORT} to ${NEW_HTTP_PORT}"
fi

if [ "${CURRENT_HTTPS_PORT}" != "${NEW_HTTPS_PORT}" ]; then
  sed -i "s/^\([ \t]\+listen[ \t]\+[]:[]*\)${CURRENT_HTTPS_PORT}\([^0-9]\)/\1${NEW_HTTPS_PORT}\2/" ${TARGET_FILE}
  echo ${NEW_HTTPS_PORT} >"${CURRENT_HTTPS_PORT_FILE}"
  echo "Switch port https ${CURRENT_HTTPS_PORT} to ${NEW_HTTPS_PORT}"
fi
