#!/usr/bin/env bash
#
# boot-jboss-server.bash - Realiza a configuração inicial do servidor para a
#                          Utilização do JBoss EAP 7.0.X
#
# Setor:      DIOP/ATI-JAVA
# Autor:      Felipe Grings
# Manutenção: Felipe Grings
#
# ------------------------------------------------------------------------ #
#  Este programa irá realizar a configuração inicial do servidor passando
#  pelas seguintes etapas:
#       * Atualizar pacotes Red Hat
#       * Instalar Libre Office
#       * Criar diretórios var/procergs
#       * Mapear os diretórios
#       * Cadastrar alisa jbosshost7-x
#       * Configurar variaveis de kernel (pid_max, ...)
#       * Instalar JDK
#       * Configurar Java Melody
#       * Configurar Crontab JBoss, Wso2 e Bonita
#       *
#       *
#
#  Exemplos:
#      $ ./boot-jboss-server.bash
#      Neste exemplo o script irá executar de forma default
#
#      $ ./boot-jboss-server.bash --homolog
#      Neste exemplo o script irá executar a preparação para servidor de homologação
#
#      $ ./boot-jboss-server.bash -h
#      Neste exemplo o script irá a opção de ajuda mostrando todas as funiconalidades
# ------------------------------------------------------------------------ #
# Histórico:
#
#   v1.0 14/10/2020, Felipe:
#       - Início do programa
#       - Conta com a funcionalidade X
# ------------------------------------------------------------------------ #
# Testado em:
#   bash 5.0.16
# ------------------------------------------------------------------------ #

# ------------------------------- VARIÁVEIS ----------------------------------------- #
AGORA="$(date +%Y%m%d-%H%M%S)"

LOG_DIR="/tmp/configjboss/"
LOG_FILE="${LOG_DIR}/log-${AGORA}.txt"

WHOAMI="$(whoami)"
USER="$WHOAMI"
GRUPO_ID="$(uid -g)"

IPS="$(hostname -I)"
SERVIDORES="$(hostname -A)"
DOMINIO="$(hostname -d)"
AMBIENTE=$(echo "${DOMINIO}" | sed -e "s/\(.*\)\..*/\1/")
DOWNLOAD_DIR="/var/procergs/procergs/jbdash/install/${AMBIENTE}"

NUM_JBOSS_SERVIDOR=


VERMELHO="\e[0;31m"
VERDE="\e[0;32m"
AZUL="\e[0;34m"
AMARELO="\e[1;33m"
SEM_COR="\e[m"
# ------------------------------------------------------------------------ #

# ------------------------------- FUNÇÕES DE LOG E TESTE ----------------------------------------- #

# Atualiza o valor de AGORA no formato 20200131-22:35:50
AtualizaAgora () {
 AGORA=`date +%Y%m%d-%H%M%S`
}

# Loga {Mensagem} {Arquivo}
# Loga na tela e no arquivo $2 a mensagem recebida. Se $2 não declarado, grava no arquivo default
Loga () {
  AtualizaAgora
  local log=$(echo ${1} | sed -e "s/\\\e\[[0-1];3[1-4]m//g" | sed -e "s/\\\e\[m//g"`)
  [ ! "${2}" ] && {
    echo "${AGORA} - $log" >> ${2}
    return
  }
  echo "${AGORA} - $log" >> ${LOG_FILE}
}

# ValidaUltimoComando {Mensagem Sucesso} {Mensagem Erro}
# Valida saída do ultimo comando: Se ok (0) Loga $1, senão Loga ${2}
ValidaUltimoComando () {
 [ $? -ne 0 ] && {
   Loga "${VERMELHO}${2}"
   return 1
 }
 Loga "${VERDE}${1}"
 return 0
}
# ------------------------------------------------------------------------ #

# ------------------------------- TESTES ----------------------------------------- #

# Tem acesso a internet?
[ ! "$(curl -s http://google.com)" ] || {
  Loga "Máquina sem acesso a internet"
  Loga "Encerrando o script!"
  exit 1
}

# É usuario root?
[ "${USER}" != "root" ] || [ "${WHOAMI}" != "root" ] || [ "${GRUPO_ID}" != "0" ] && {
  Loga "Executar o script de configuracao como user root"
  Loga "Encerrando o script!"
  exit 1
}

# JBoss já instalado?
if [ -e ${JBOSS_HOME} ]; then
    Loga "Este servidor ja tem uma instalacao de JBoss em: "
    Loga "${JBOSS_HOME} !"
    Loga "Configuracao interrompida"
    exit 2
fi

# ------------------------------------------------------------------------ #

# ------------------------------- FUNÇÕES ----------------------------------------- #
LiberaSudoParaUsuarios () {
  echo 'cHJvY2VyZ3MtY2FybG9zLWNyZXN0YW5pICAgICAgICBBTEw9KEFMTCkgQUxMCg=='|base64 -d >>/etc/sudores
  echo 'cHJvY2VyZ3MtbWFyY2lvLXBvbXBlcm1heWVyICAgICBBTEw9KEFMTCkgQUxMCg=='|base64 -d >> /etc/sudores
  echo "${USUARIO}   ALL=(ALL)       NOPASSWD:/usr/bin/systemctl *" >> /etc/sudores
}

AtualizaPacotesRH () {
  for pacote in samba-client libpng12 compat-libtiff3 libtiff libtiff-devel libtiff-static libtiff-tools gdk-pixbuf2 gdk-pixbuf2-devel gtk2 wkhtmltopdf ghostscript-fonts ghostscript cifs-utils  httpd-2.4.6-67.el7_4.5.x86_64
  do
      echo "Instalando pacote ${pacote}"
      yum -y install ${pacote}
      ValidaUltimoComando "Pacote ${pacote} instalado com sucessou" "Erro na instalacao do pacote ${pacote}"
  done
}

InstalaLibreOffice () {
  yum install libreoffice-5.3.6.1-21.el7
  ValidaUltimoComando "Libre Office Instalado com sucesso" "Erro na instalação do Libre Office"

  /usr/lib64/libreoffice/program/soffice.bin --accept=socket,host=127.0.0.1,port=2020,tcpNoDelay=1;urp;StarOffice.ServiceManager \
                                             --headless --invisible --nocrashreport --nodefault --nofirststartwizard --nolockcheck --nologo --norestore \
                                             -env:UserInstallation=file:///tmp/.jodconverter_socket_host-127.0.0.1_port-2020_tcpNoDelay-1
  ValidaUltimoComando "Libre Office Validado" "Erro na execução do Libre Office"

}

CriaDiretorios () {
  for dir in detran detran/cev documentum infra jboss jboss/dump jboss/javamelody jboss/stats procergs procergssmb sarh/gpe sec;  do
    if [ ! -e "/var/procergs/$dir" ]; then
      Loga "Criando diretorio $dir"
      mkdir -p /var/procergs/$dir
      ValidaUltimoComando "Diretorio $dir criado com sucesso" "Erro ao criar diretorio $dir"
      chown $USUARIO:$GRUPO /var/procergs/$dir
    else
      Loga "$dir ja existe"
    fi
  done
  Loga "Verificando /var/procergs/procergs"
  if [ -e /var/procergs/procergs/jbdash ]; then
    local nfs_procergs=0
    Loga "${AMARELO}/var/procergs/procergs ${VERDE} Montado!"
  else
    mount /var/procergs/procergs
    ValidaUltimoComando "Diretorio /var/procergs/procergs/ Montado com Sucesso!" "Diretorio /var/procergs/procergs/ NAO foi montado!"
    if [ $? = 0 ]; then
      nfs_procergs=0
    else
      nfs_procergs=1
    fi
  fi
}

MontaNFS () {
#   Pontos de montagem default para homologação:
mount -F nfs -ro 10.244.0.143:/exports/noarch/jboss /jboss
ValidaUltimoComando "Diretorio /var/procergs/procergs/ Montado com Sucesso!" "Diretorio /var/procergs/procergs/ NAO foi montado!"

mount -F nfs -rw 10.244.0.55:/exports/noarch/sistemas /var/procergs/procergs
mount -F nfs -rw 10.244.0.55:/exports/noarch/home /home/procergs

# Outros pontos de montagem nfs:
mount -F nfs -rw 10.244.0.55:/exports/noarch/detran-gpd /var/procergs/detran/gpd
mount -F nfs -ro 10.127.9.13:/usr/local/www/data/mrtg/Clientes /var/procergs/infra/mrtg

# REQ206954 10.127.9.13:/usr/local/www/data/mrtg/Clientes -> /var/procergs/infra/mrtg (read-only
}

# NÃO ENTENDI
MontaSamba () {
  cat ${DOWNLOAD_DIR}/samba.txt >> /etc/fstab
  cd /etc/samba/
  tar -xzvf ${DOWNLOAD_DIR}/cifs
  for pass in *pass ; do
    cat $pass | base64 -d > $pass
  done
}


# ValidaValorConf {Valor lido} {Valor Previsto} {Variavel}
ValidaValorConf () {
  [ ! "$1" ] && {
    Loga "${VERMELHO}NOK - ${AMARELO}$3 nao definida!"
    return 1
  }
  [ "$1" != "$2" ] && {
    Loga "${VERMELHO}NOK - ${AMARELO}$3 Valor incorreto!"
    return 2
  }
  Loga "${VERMELHO}OK - ${AMARELO}$3 Valor correto!"
}

# Aumenta configurações de inotify, openfiles e kernel.pid_max
AumentaConfEtc ( ) {
  local kernel_pid_max=262140
  local max_user_watches=65536
  local max_user_instances=256
  local nofile=65536
  local stack=262144
  local nproc=256808


  # Aumenta Kernel PID
  echo 262140 > /proc/sys/kernel/pid_max
  ValidaValorConf $(tail -1 /proc/sys/kernel/pid_max  | sed -e "s/.*=\ //") kernel_pid_max "/proc/sys/kernel/pid_max"

  echo "kernel.pid_max = 262140" >> /etc/sysctl.d/99-sysctl.conf
  ValidaValorConf $(tail -1 /etc/sysctl.d/99-sysctl.conf  | sed -e "s/.*=\ //") kernel_pid_max "99-sysctl.conf kernel.pid_max"


  # Aumetar os inotify do sistema
  echo "fs.inotify.max_user_watches = 65536" >> /etc/sysctl.d/99-sysctl.conf
  ValidaValorConf $(tail -1 /etc/sysctl.d/99-sysctl.conf  | sed -e "s/.*=\ //") max_user_watches "max_user_watches"

  echo "fs.inotify.max_user_instances = 256" >> /etc/sysctl.d/99-sysctl.conf
  ValidaValorConf $(tail -1 /etc/sysctl.d/99-sysctl.conf  | sed -e "s/.*=\ //") max_user_instances "max_user_instances"

  # Aumentar o # openfiles no /etc/security/limits.conf
  echo "${USUARIO}       soft    nofile      65536" >> /etc/security/limits.conf
  ValidaValorConf $(tail -1 /etc/security/limits.conf  | sed -e "s/.*=\ //") nofile "soft nofile"

  echo "${USUARIO}       hard    nofile      65536" >> /etc/security/limits.conf
  ValidaValorConf $(tail -1 /etc/security/limits.conf  | sed -e "s/.*=\ //") nofile "hard nofile"

  echo "${USUARIO}       soft    stack       262144" >> /etc/security/limits.conf
  ValidaValorConf $(tail -1 /etc/security/limits.conf  | sed -e "s/.*=\ //") stack "soft stack"

  echo "${USUARIO}       hard    stack       262144" >> /etc/security/limits.conf
  ValidaValorConf $(tail -1 /etc/security/limits.conf  | sed -e "s/.*=\ //") stack "hard stack"

  echo "${USUARIO}       soft    nproc       256808" >> /etc/security/limits.conf
  ValidaValorConf $(tail -1 /etc/security/limits.conf  | sed -e "s/.*=\ //") nproc "soft nproc"

  echo "${USUARIO}       hard    nproc       256808" >> /etc/security/limits.conf
  ValidaValorConf $(tail -1 /etc/security/limits.conf  | sed -e "s/.*=\ //") nproc "hard nproc"

  /sbin/sysctl --system

  # sed para adicionar ao /etc/profile: export HISTTIMEFORMAT=.%Y%m%d %T .
  # testar se ja existe um HISTTIMEFORMAT configurado
  sed -i "/export/i\export HISTTIMEFORMAT=\"%Y%m%d %Ti\" \n" /etc/profile
}

InstalaJDK () {
  Loga "Instalando JDK"
  cp /jboss/installs/jdk-8u231-linux-x64.tar /opt/java
  tar -xzvf /opt/java/jdk-8u231-linux-x64.tar
  ln -s /opt/java/jdk1.8.0_231 jdk1.8
  unlink /etc/alternatives/java
  ln -s /opt/java/jdk1.8/bin/java
  ln -s /nfs/security/ /opt/security
}

ConfiguraCrontab () {
  ln -s /jboss/scripts/cleanLogs.sh /etc/cron.weekly/cleanLogs.sh
  ln -s /jboss/scripts/cleanTemp.sh /etc/cron.weekly/cleanTemp.sh
  ln -s /jboss/scripts/setPermissions.sh /etc/cron.weekly/setPermissions.sh
}

InstalaJBoss () {
  cd /opt/
  tar -xzvf ${DOWNLOAD_DIR}/jboss-7.0-template.tar.gz
  local modulos="${JBOSS_HOME}/modules/procergs"
  if [ -e $modulos ]; then
      echo "Link modules/procergs ja existe"
  else
      cd /opt/${JBOSS_HOME}/modules
      ln -s /jboss/jboss-modules/${AMBIENTE}/procergs
      if [ -e /opt/properties ] ; then
  fi
      echo "/opt/properties ja existe"
  else
      ln -s /jboss/properties/${AMBIENTE}
  fi

  #NO HOST.XML
  local host_xml="${JBOSS_HOME}/domain/configuration/host.xml"
  local ip_servidor="jbosshost7-${NUM_JBOSS_SERVIDOR}.${AMBIENTE}.intra.rs.gov.br"
  #substituir jbosshost7-# por jbosshost7-[0-9]*[0-9]
  sed -i "s/jbosshost7-\#/jbosshost7-${NUM_JBOSS_SERVIDOR}/g" ${host_xml}
  #substituir AMBIENTE por ${AMBIENTE}
  sed -i "s/AMBIENTE\#/${AMBIENTE}/g" ${host_xml}
  #substituir ip_desta_maquina pelo ip do server
  sed -i "s/ip_desta_maquina\#/${ip_servidor}/g" ${host_xml}

  #cadastrar como servico


  # Descompatar tar.gzs
  # opt_griaule-libs.tar.gz e trutype.tar.gz
  Loga "Verificando fontes trutype em /usf/share/fonts"
  if [ ! -e /usr/share/fonts/truetype ] ; then
      Loga "Instalando fonts truetype"
      cd /usr/share/fonts/
      tar -xzvf ${DOWNLOAD_DIR}/truetype.tar.gz 1>> ${LOG_DIR}/truetypelog.txt 2>> ${LOG_DIR}/truetypeerro.txt
  else
      Loga "Ja existe diretorio /usr/share/fonts/truetype"
  fi

  Loga "Verificando griaule-libs /opt/griaule-libs"
  if [ ! -e /opt/griaule-libs ] ; then
      Loga "${VERDE}Instalando griaule-libs"
      cd /opt/
      tar -xzvf ${DOWNLOAD_DIR}/griuale-libs.tar.gz 1>> ${LOG_DIR}/griuale-libslog.txt 2>> ${LOG_DIR}/griuale-libserro.txt
  else
      Loga "Ja existe o diretorio ${VERMELHO}/opt/griaule-libs"
  fi
}

# ------------------------------------------------------------------------ #

# ------------------------------- EXECUÇÃO ----------------------------------------- #
# ------------------------------------------------------------------------ #
