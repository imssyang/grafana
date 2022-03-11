#!/bin/bash

APP=grafana
HOME=/opt/$APP
SYSD=/etc/systemd/system

_mkdir() {
  name=$1
  if [[ ! -d $name ]]; then
    mkdir -p $name
  fi
}

_rmdir() {
  name=$1
  if [[ -d $name ]]; then
    rm -rf $name
  fi
}

_create_symlink() {
  src=$1
  dst=$2
  if [[ ! -d $dst ]] && [[ ! -s $dst ]]; then
    ln -s $src $dst
    echo "($APP) create symlink: $src -> $dst"
  fi
}

_delete_symlink() {
  dst=$1
  if [[ -d $dst ]] || [[ -s $dst ]]; then
    rm -rf $dst
    echo "($APP) delete symlink: $dst"
  fi
}

_enable_service() {
  name=$1
  _create_symlink $HOME/setup/$name $SYSD/$name
  systemctl enable $name
  systemctl daemon-reload
}

_disable_service() {
  name=$1
  systemctl disable $name
  systemctl daemon-reload
  _delete_symlink $SYSD/$name
}

_start_service() {
  name=$1
  systemctl start $name
  systemctl status $name
}

_stop_service() {
  name=$1
  systemctl stop $name
  systemctl status $name
}

init() {
  _mkdir $HOME/data
  _mkdir $HOME/var
  _mkdir $HOME/var/log

  chown -R root:root $HOME
  chmod 755 $HOME

  _enable_service grafana-server.service
  _enable_service grafana-agent.service
}

deinit() {
  _rmdir $HOME/data
  _rmdir $HOME/var
  _rmdir $HOME/var/log
  _disable_service grafana-server.service
  _disable_service grafana-agent.service
}

start() {
  _start_service grafana-server.service
  _start_service grafana-agent.service
}

stop() {
  _stop_service grafana-server.service
  _stop_service grafana-agent.service
}

show() {
  systemctl status grafana-server.service
  systemctl status grafana-agent.service
}

case "$1" in
  init) init ;;
  deinit) deinit ;;
  start) start ;;
  stop) stop ;;
  show) show ;;
  *) SCRIPTNAME="${0##*/}"
     echo "Usage: $SCRIPTNAME {init|deinit|start|stop|show}"
     exit 3
     ;;
esac

exit 0

# vim: syntax=sh ts=4 sw=4 sts=4 sr noet
