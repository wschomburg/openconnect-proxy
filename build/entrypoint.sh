#!/bin/sh

sed "s/^Port .*$/Port 8888/" -i /etc/tinyproxy.conf
/usr/bin/tinyproxy -c /etc/tinyproxy.conf

/usr/local/bin/microsocks -i 0.0.0.0 -p 8889 & 

# Pivoxy config and start
find /etc/privoxy -type f -name '*.new' | while read f; do mv "$f" "${f%.new}"; done

sed -i "s/listen\-address  127\.0\.0\.1:8118/listen\-address  0\.0\.0\.0:8118/" /etc/privoxy/config

privoxy /etc/privoxy/config

run () {
  # Start openconnect
  if [[ -z "${OPENCONNECT_PASSWORD}" ]]; then
  # Ask for password
    openconnect -u "$OPENCONNECT_USER" $OPENCONNECT_OPTIONS $OPENCONNECT_URL
  elif [[ ! -z "${OPENCONNECT_PASSWORD}" ]] && [[ ! -z "${OPENCONNECT_MFA_CODE}" ]]; then
  # Multi factor authentication (MFA)
    (echo $OPENCONNECT_PASSWORD; echo $OPENCONNECT_MFA_CODE) | openconnect -u "$OPENCONNECT_USER" $OPENCONNECT_OPTIONS --passwd-on-stdin $OPENCONNECT_URL
  elif [[ ! -z "${OPENCONNECT_PASSWORD}" ]]; then
  # Standard authentication
    echo $OPENCONNECT_PASSWORD | openconnect -u "$OPENCONNECT_USER" $OPENCONNECT_OPTIONS --passwd-on-stdin $OPENCONNECT_URL
  fi
}

until (run); do
  echo "openconnect exited. Restarting process in 60 seconds…" >&2
  sleep 60
done

