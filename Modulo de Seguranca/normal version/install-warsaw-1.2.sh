#!/usr/bin/env bash
#
# install-warsaw-1.2.sh - Instala o Módulo de Segurança dos Bancos
#
# Site:     
# Autor:      Flávio Varejão
# Manutenção: Flávio Varejão
# -------------------------------------------------------------------------------------------------------------------------------- #
# Este script irá instalar a última versão do Módulo de Segurança dos Bancos no Linux
#
# Exemplos:
#   $ ./install-warsaw-1.2.sh -b
#   Neste exemplo o script vai instalar o módulo do Banco do Brasil.
#
# Na seção de variáveis é possível alterar as URLs (em SITE) e o nome do arquivo (em ARQUIVO) 
# caso tenham sofrido alguma mudança no servidor.   
# -------------------------------------------------------------------------------------------------------------------------------- #
# Histórico:
#   v1.0 25/02/2020, Flávio:
#   - Início do programa
#
#   v1.1 26/02/2020, Flávio:
#   - Indentação do código
#   - Encurtamento de comandos
#
#   V1.2 27/02/2020, Flávio:
#   - Criação dos vetores SITE e ARQUIVO             
# -------------------------------------------------------------------------------------------------------------------------------- #
# Testado em:
# bash 4.4.20
# -------------------------------------------------------------------------------------------------------------------------------- #
# ---------------------------------------- VARIÁVEIS-------------------------------------------------- #
AMARELO="\033[33;1m"
VERMELHO="\033[31;1m"
VERDE="\033[32;1m"
MENU=" 
 $0 -[OPÇÕES]

   -g - Genérico (Desenvolvedor)
   -b - Banco do Brasil
   -c - Caixa Econômica
   -i - Banco Itaú
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
)
# -------------------------------------------------------------------------------------------------------------------------------- #
# ----------------------------------------- TESTES --------------------------------------------------- #
# warsaw instalado?
[ -x "$(which warsaw)" ] && { 
  echo -e "${VERDE}Módulo de segurança já está instalado!" && tput sgr0
  dpkg -s warsaw && exit 0
}
# --------------------------------------------------------------------------------------------------------------------------------- #
# ----------------------------------------- FUNÇÕES -------------------------------------------------- #
Instalacao () {
  [ ! -x "$(which wget)" ] && sudo apt install wget -y # wget instalado?
  wget -c "$SITE"
  [ ! -f "$ARQUIVO" ] && echo -e "${VERMELHO}Falha no download! Instalação abortada." && tput sgr0 && exit 1
  sudo apt update && sudo dpkg -i "$ARQUIVO" && sudo apt -f install -y
  echo -e "${AMARELO}Por favor reinicie seu computador para ativar o serviço." && tput sgr0 && exit 0
}
# --------------------------------------------------------------------------------------------------------------------------------- #
# ----------------------------------------- EXECUÇÃO ------------------------------------------------- #
echo "Instalação do Módulo de Segurança..."
echo "Por favor, selecione qual módulo você deseja instalar." && echo "$MENU"
if [ "$(uname -m)" != "x86_64" ]; then
  while test -n "$1"; do
    case "$1" in
      -g) SITE=${SITE[0]} ARQUIVO=${ARQUIVO[0]} ;;
      -b) SITE=${SITE[2]} ARQUIVO=${ARQUIVO[2]} ;;
      -c) SITE=${SITE[4]} ARQUIVO=${ARQUIVO[4]} ;;
      -i) SITE=${SITE[6]} ARQUIVO=${ARQUIVO[6]} ;;
       *) echo -e "${VERMELHO}Opção inválida, selecione uma opção!" && tput sgr0 && exit 1 ;;
    esac
    Instalacao
  done
else
  while test -n "$1"; do
    case "$1" in
      -g) SITE=${SITE[1]} ARQUIVO=${ARQUIVO[1]} ;;
      -b) SITE=${SITE[3]} ARQUIVO=${ARQUIVO[3]} ;;
      -c) SITE=${SITE[5]} ARQUIVO=${ARQUIVO[5]} ;;
      -i) SITE=${SITE[7]} ARQUIVO=${ARQUIVO[7]} ;;
       *) echo -e "${VERMELHO}Opção inválida, selecione uma opção!" && tput sgr0 && exit 1 ;;
    esac
    Instalacao
  done
fi
# --------------------------------------------------------------------------------------------------------------------------------- #
