#!/usr/bin/env ash

if [ "${1}" = "late" ]; then
  echo "Installing addon synocodec patch"
  cp -v /usr/bin/codecpatch.sh /tmpRoot/usr/bin/codecpatch.sh
  cp -v /usr/lib/systemd/system/codecpatch.service /tmpRoot/usr/lib/systemd/system/codecpatch.service
  mkdir -vp /tmpRoot/lib/systemd/system/multi-user.target.wants
  ln -vsf /usr/lib/systemd/system/codecpatch.service /tmpRoot/lib/systemd/system/multi-user.target.wants/codecpatch.service
fi
