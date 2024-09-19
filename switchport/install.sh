#!/usr/bin/env ash

if [ "${1}" = "late" ]; then
  echo "Installing daemon for switchport"
  cp -vf /usr/sbin/switchport.sh /tmpRoot/usr/sbin/switchport.sh
  shift

  DEST="/tmpRoot/lib/systemd/system/switchport.service"
  echo "[Unit]" >${DEST}
  echo "Description=Desallocates ports http(s)" >>${DEST}
  echo "After=multi-user.target" >>${DEST}
  echo "Before=nginx.service" >>${DEST}
  echo >>${DEST}
  echo "[Service]" >>${DEST}
  echo "Type=oneshot" >>${DEST}
  echo "RemainAfterExit=true" >>${DEST}
  echo "ExecStart=/usr/sbin/switchport.sh $1 $2" >>${DEST}
  echo "ExecStartPost=/bin/systemctl try-restart nginx" >>${DEST}
  echo >>${DEST}
  echo "[Install]" >>${DEST}
  echo "WantedBy=multi-user.target" >>${DEST}

  mkdir -vp /tmpRoot/lib/systemd/system/multi-user.target.wants
  ln -vsf /lib/systemd/system/switchport.service /tmpRoot/lib/systemd/system/multi-user.target.wants/switchport.service
fi
