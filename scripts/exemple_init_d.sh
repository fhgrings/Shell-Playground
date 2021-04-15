#! /bin/bash
#
# modjk       Bring up/down networking
# chkconfig: - 50 50
# description: Activates/Deactivates all network interfaces configured to \
#              start at boot time.
#
# exemple_init_d.sh - Automação para inicialização de script
#
# Autor:      Felipe Grings
#
# ------------------------------------------------------------------------ #
#  Configuração
#       * Criar o script no diretório /etc/init.d/script.sh
#       * Habilitar o script com o comando:
#             $ chkconfig --add script.sh
#             $ chkconfig --level 2345 script.sh on
#       * Verificar  se o script está habilitado
#             $ chkconfig --list | grep script
#
# ------------------------------------------------------------------------ #
# Histórico:
#
#   v1.0 14/10/2020, Felipe:
#       - Início do programa
# ------------------------------------------------------------------------ #
# Testado em:
#   bash 5.0.16
# ------------------------------------------------------------------------ #

# ------------------------------- VARIÁVEIS ----------------------------------------- #

SCRIPT="apachectl -k start"
RUNAS="root"
NAME="modjk"

PIDFILE=/var/run/${NAME}.pid
LOGFILE=/var/log/${NAME}.log

start() {
  if [ -f /var/run/$PIDNAME ] && kill -0 $(cat /var/run/$PIDNAME); then
    echo 'Service already running' >&2
    return 1
  fi
  echo 'Starting service…' >&2
  local CMD="$SCRIPT &> \"$LOGFILE\" & echo \$!"
  su -c "$CMD" $RUNAS > "$PIDFILE"
  echo 'Service started' >&2
}

stop() {
  if [ ! -f "$PIDFILE" ] || ! kill -0 $(cat "$PIDFILE"); then
    echo 'Service not running' >&2
    return 1
  fi
  echo 'Stopping service…' >&2
  kill -15 $(cat "$PIDFILE") && rm -f "$PIDFILE"
  echo 'Service stopped' >&2
}

uninstall() {
  echo -n "Are you really sure you want to uninstall this service? That cannot be undone. [yes|No] "
  local SURE
  read SURE
  if [ "$SURE" = "yes" ]; then
    stop
    rm -f "$PIDFILE"
    echo "Notice: log file is not be removed: '$LOGFILE'" >&2
    update-rc.d -f ${NAME} remove
    rm -fv "$0"
  fi
}

case "$1" in
  start)
    start
    ;;
  stop)
    stop
    ;;
  uninstall)
    uninstall
    ;;
  retart)
    stop
    start
    ;;
  *)
    echo "Usage: $0 {start|stop|restart|uninstall}"
esac
