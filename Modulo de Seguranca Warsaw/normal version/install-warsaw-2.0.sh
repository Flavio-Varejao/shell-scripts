#!/usr/bin/env bash
#
# install-warsaw-2.0.sh - Instala o Módulo de Segurança dos Bancos
#
# Site:     
# Autor:      Flávio Varejão
# Manutenção: Flávio Varejão
# -------------------------------------------------------------------------------------------------------------------------------- #
# Este script irá instalar a última versão do Módulo de Segurança dos Bancos no Linux
#
# O script suporta arquivos deb e rpm, logo é compatível com distros que utilizam o gerenciador 
# de pacotes dpkg, zypper e dnf (Ubuntu, Fedora, OpenSUSE, etc).
#
# Como usar:
#
#   Primeiro acesso (permissão de execução):
#     $ chmod +x install-warsaw-2.0.sh
#
#   Exemplo de uso:
#     $ ./install-warsaw-2.0.sh -b
#     Neste exemplo o script vai instalar o módulo do Banco do Brasil.
#
# Na seção de variáveis é possível alterar as URLs (em SITE) e o nome do arquivo (em ARQUIVO) 
# caso tenham sofrido alguma mudança no servidor.   
# -------------------------------------------------------------------------------------------------------------------------------- #
# Histórico:
#   v1.0 25/02/2020, Flávio:
#     - Início do programa
#
#   v1.1 26/02/2020, Flávio:
#     - Indentação do código
#     - Encurtamento de comandos
#
#   V1.2 27/02/2020, Flávio:
#     - Criação dos vetores SITE e ARQUIVO
#
#   V1.3 24/03/2020, Flávio:
#     - Adicionado a opção de Ajuda
#     - Adicionado a opção de Versão
#     - Pequenas alterações
#
#   V1.4 11/05/2020, Flávio:
#     - Adicionado a opção de exibir informações do pacote
#     - Adicionado a opção de remover o pacote
#   
#   V2.0 21/05/2020, Flavio:
#     - Adicionado suporte a arquivos rpm (zypper e dnf)
# -------------------------------------------------------------------------------------------------------------------------------- #
# Testado em:
#   bash 4.4.20
# -------------------------------------------------------------------------------------------------------------------------------- #
# ---------------------------------------- VARIÁVEIS-------------------------------------------------- #
VERSAO="install-warsaw Versão 2.0
"
VERDE="\033[32;1m"
AMARELO="\033[33;1m"
VERMELHO="\033[31;1m"

MENU_INSTALACAO_DEB=" 
 $0 [-OPÇÃO]

   -g  Genérico (Desenvolvedor)
   -b  Banco do Brasil
   -c  Caixa Econômica
   -i  Banco Itaú
   -V  Versão do programa
   -h  Ajuda
"
MENU_INSTALACAO_RPM="
 $0 [-OPÇÃO]

   -g  Genérico (Desenvolvedor)
   -V  Versão do programa
   -h  Ajuda
" 
MENU_PACOTE="
 $0 [-OPÇÃO]

    1) Exibir informações do pacote
    2) Remover o pacote
"
AJUDA="
    $0 [-h] [--help]
      
       -g  Instala o Módulo de Segurança do site do desenvolvedor
       -b  Instala o Módulo de Segurança do site do Banco do Brasil
       -c  Instala o Módulo de Segurança do site da Caixa Econômica
       -i  Instala o Módulo de Segurança do site do Banco Itaú
       -V, --version  Exibe a versão deste programa e sai
       -h, --help  Exibe esta tela de ajuda e sai
"
SITE=(
  "https://cloud.gastecnologia.com.br/gas/diagnostico/warsaw_setup_32.deb" \
  "https://cloud.gastecnologia.com.br/gas/diagnostico/warsaw_setup_64.deb" \
  "https://cloud.gastecnologia.com.br/bb/downloads/ws/warsaw_setup.deb" \
  "https://cloud.gastecnologia.com.br/bb/downloads/ws/warsaw_setup64.deb" \
  "https://imagem.caixa.gov.br/banner/fgr/GBPCEFwr32.deb" \
  "https://imagem.caixa.gov.br/banner/fgr/GBPCEFwr64.deb" \
  "https://guardiao.itau.com.br/warsaw/warsaw_setup_32.deb" \
  "https://guardiao.itau.com.br/warsaw/warsaw_setup_64.deb" \
  "https://cloud.gastecnologia.com.br/gas/diagnostico/warsaw_setup_32.rpm" \
  "https://cloud.gastecnologia.com.br/gas/diagnostico/warsaw_setup_64.rpm" \
  "https://cloud.gastecnologia.com.br/gas/diagnostico/warsaw_setup_opensuse_64.rpm" \
)
ARQUIVO=(
  "warsaw_setup_32.deb" \
  "warsaw_setup_64.deb" \
  "warsaw_setup.deb" \
  "warsaw_setup64.deb" \
  "GBPCEFwr32.deb" \
  "GBPCEFwr64.deb" \
  "warsaw_setup_32.deb" \
  "warsaw_setup_64.deb" \
  "warsaw_setup_32.rpm" \
  "warsaw_setup_64.rpm" \
  "warsaw_setup_opensuse_64.rpm" \
)
# -------------------------------------------------------------------------------------------------------------------------------- #
# ----------------------------------------- TESTES --------------------------------------------------- #
# warsaw instalado?
[ -x "$(which warsaw 2> /dev/null)" ] && {
  echo -e "\n${VERDE}Módulo de segurança já está instalado! \n" && tput sgr0
  echo "Selecione uma opção" && echo "$MENU_PACOTE"
  if [ -x "$(which dpkg 2> /dev/null)" ]; then
    while test -n "$1"; do
      case "$1" in
        1) dpkg -s warsaw && exit 0                                                            ;;
        2) sudo dpkg -r warsaw && exit 0                                                       ;;
        *) echo -e "${VERMELHO}Opção inválida, selecione uma opção! \n" && tput sgr0 && exit 1 ;;
      esac
      exit 0
    done 
    exit 0
  elif [ -x "$(which zypper 2> /dev/null)" ]; then
    while test -n "$1"; do
      case "$1" in
        1) zypper info warsaw && exit 0                                                        ;;
        2) sudo zypper remove warsaw && exit 0                                                 ;;
        *) echo -e "${VERMELHO}Opção inválida, selecione uma opção! \n" && tput sgr0 && exit 1 ;;
      esac
      exit 0
    done 
    exit 0
  else
    while test -n "$1"; do
      case "$1" in
        1) dnf info warsaw && exit 0                                                           ;;
        2) sudo dnf remove warsaw && exit 0                                                    ;;
        *) echo -e "${VERMELHO}Opção inválida, selecione uma opção! \n" && tput sgr0 && exit 1 ;;
      esac
      exit 0
    done 
    exit 0  
  fi  
}
# --------------------------------------------------------------------------------------------------------------------------------- #
# ----------------------------------------- FUNÇÕES -------------------------------------------------- #
Instalacao_Deb () {
  [ ! -x "$(which wget)" ] && sudo apt install wget -y # wget instalado?
  wget -c "$SITE"
  [ ! -f "$ARQUIVO" ] && echo -e "${VERMELHO}Falha no download! Instalação abortada." && tput sgr0 && exit 1
  sudo dpkg -i "$ARQUIVO" -y && sudo apt -f install -y
  echo -e "\n${AMARELO}Por favor reinicie seu computador para ativar o serviço. \n" && tput sgr0 && exit 0
}
Instalacao_Rpm_1 () {
  [ ! -x "$(which wget)" ] && sudo zypper install -y wget # wget instalado?
  wget -c "$SITE"
  [ ! -f "$ARQUIVO" ] && echo -e "${VERMELHO}Falha no download! Instalação abortada." && tput sgr0 && exit 1
  sudo zypper --no-gpg-checks install -y "$ARQUIVO"
  echo -e "\n${AMARELO}Por favor reinicie seu computador para ativar o serviço. \n" && tput sgr0 && exit 0
}
Instalacao_Rpm_2 () {
  [ ! -x "$(which wget)" ] && sudo dnf install -y wget # wget instalado?
  wget -c "$SITE"
  [ ! -f "$ARQUIVO" ] && echo -e "${VERMELHO}Falha no download! Instalação abortada." && tput sgr0 && exit 1
  sudo dnf localinstall -y "$ARQUIVO"
  echo -e "\n${AMARELO}Por favor reinicie seu computador para ativar o serviço. \n" && tput sgr0 && exit 0
}
# --------------------------------------------------------------------------------------------------------------------------------- #
# ----------------------------------------- EXECUÇÃO ------------------------------------------------- #
echo -e "\nInstalação do Módulo de Segurança..."
if [ -x "$(which dpkg 2> /dev/null)" ]; then
  echo "Por favor, selecione uma opção" && echo "$MENU_INSTALACAO_DEB"
  if [ "$(uname -m)" != "x86_64" ]; then
    while test -n "$1"; do
      case "$1" in
        -g) SITE=${SITE[0]} ARQUIVO=${ARQUIVO[0]} ;;
        -b) SITE=${SITE[2]} ARQUIVO=${ARQUIVO[2]} ;;
        -c) SITE=${SITE[4]} ARQUIVO=${ARQUIVO[4]} ;;
        -i) SITE=${SITE[6]} ARQUIVO=${ARQUIVO[6]} ;;
        -h | --help) echo "$AJUDA" && exit 0      ;;
        -V | --version) echo "$VERSAO" && exit 0  ;;
        *) echo -e "${VERMELHO}Opção inválida, selecione uma opção! \n" && tput sgr0 && exit 1 ;;
      esac
      Instalacao_Deb
    done
  else
    while test -n "$1"; do
      case "$1" in
        -g) SITE=${SITE[1]} ARQUIVO=${ARQUIVO[1]} ;;
        -b) SITE=${SITE[3]} ARQUIVO=${ARQUIVO[3]} ;;
        -c) SITE=${SITE[5]} ARQUIVO=${ARQUIVO[5]} ;;
        -i) SITE=${SITE[7]} ARQUIVO=${ARQUIVO[7]} ;;
        -h | --help) echo "$AJUDA" && exit 0      ;;
        -V | --version) echo "$VERSAO" && exit 0  ;;
        *) echo -e "${VERMELHO}Opção inválida, selecione uma opção! \n" && tput sgr0 && exit 1 ;;
      esac
      Instalacao_Deb
    done
  fi
elif [ -x "$(which zypper 2> /dev/null)" ]; then
  echo "Por favor, selecione uma opção" && echo "$MENU_INSTALACAO_RPM"
  while test -n "$1"; do
    case "$1" in
      -g) SITE=${SITE[10]} ARQUIVO=${ARQUIVO[10]} ;;
      -h | --help) echo "$AJUDA" && exit 0        ;;
      -V | --version) echo "$VERSAO" && exit 0    ;;
        *) echo -e "${VERMELHO}Opção inválida, selecione uma opção! \n" && tput sgr0 && exit 1 ;;
    esac
    Instalacao_Rpm_1
  done  
else
  echo "Por favor, selecione uma opção" && echo "$MENU_INSTALACAO_RPM"
  if [ "$(uname -m)" != "x86_64" ]; then
    while test -n "$1"; do
      case "$1" in
        -g) SITE=${SITE[8]} ARQUIVO=${ARQUIVO[8]} ;;
        -h | --help) echo "$AJUDA" && exit 0      ;;
        -V | --version) echo "$VERSAO" && exit 0  ;;
        *) echo -e "${VERMELHO}Opção inválida, selecione uma opção! \n" && tput sgr0 && exit 1 ;;
      esac
      Instalacao_Rpm_2
    done
  else
    while test -n "$1"; do
      case "$1" in
        -g) SITE=${SITE[9]} ARQUIVO=${ARQUIVO[9]} ;;
        -h | --help) echo "$AJUDA" && exit 0      ;;
        -V | --version) echo "$VERSAO" && exit 0  ;;
        *) echo -e "${VERMELHO}Opção inválida, selecione uma opção! \n" && tput sgr0 && exit 1 ;;
      esac
      Instalacao_Rpm_2
    done
  fi    
fi  
# --------------------------------------------------------------------------------------------------------------------------------- #
