#!/bin/sh

if [ "$(id -u)" = "0" ]; then
  if [ -n "${XUID}" ] && [ -n "${XGID}" ]; then
      export USER=dev

      # Cambiamos el id del usuario dev
      usermod -u ${XUID} dev 2> /dev/null && {
          groupmod -g ${XGID} dev 2> /dev/null || usermod -a -G ${XGID} dev
      }

      exec gosu dev "$@"
  fi
fi

# Ejecutamos el comando normal
exec "$@"

# Hay otro metodo para impersonal el usuario creando el usuario al momento de entrar al endpoint
# ESto era otro metodo para impersonar el usuario especificado poc XUID.
# Que crea el usuario al vuelo.
#
#XGROUP="$(getent group "${XGID}" | cut -d: -f1)"
#if [ -z "${XUSER}" ]; then
#    XGROUP="developer"
#    groupadd -g "${XGID}" "developer"
#fi

#XUSER="$(getent passwd "${XUID}" | cut -d: -f1)"
#if [ -z "${XUSER}" ]; then
#    XUSER="developer"
#    useradd -u "${XUID}" -g "${XGID}" "developer"
#fi