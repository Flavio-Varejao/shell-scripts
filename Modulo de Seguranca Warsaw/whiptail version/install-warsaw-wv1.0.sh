#!/usr/bin/env bash
#
# install-warsaw-wv1.0.sh - Instala o Módulo de Segurança dos Bancos
#
# Site:     
# Autor:      Flávio Varejão
# Manutenção: Flávio Varejão
# ---------------------------------------------------------------------------------------------------------------------------------------------- #
# Este script irá instalar a última versão do Módulo de Segurança dos Bancos no Linux utilizando O WHIPTAIL (caixas de diálogo).
# Leia as instruções a seguir.
#
# Exemplo:
#   $ ./install-warsaw-wv1.0.sh
#   Neste exemplo o script será executado.
#
# Na seção de variáveis é possível alterar as URLs (em SITE) e o nome do arquivo (em ARQUIVO) caso tenham sofrido alguma mudança no servidor.   
# ---------------------------------------------------------------------------------------------------------------------------------------------- #
# Histórico:
#   Versão 1.0, Flávio:
#     15/03/2020
#       - Início do programa
#     12/05/2020
#       - Adicionado a opção de exibir informações do pacote
#       - Adicionado a opção de remover o pacote
# ---------------------------------------------------------------------------------------------------------------------------------------------- #
# Testado em:
#   bash 4.4.20
# ---------------------------------------------------------------------------------------------------------------------------------------------- #
# ------------------------------------------------------- VARIÁVEIS----------------------------------------------------------------- #
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
TEMP=temp.$$
# ---------------------------------------------------------------------------------------------------------------------------------------------- #
# -------------------------------------------------------- TESTES ------------------------------------------------------------------ # 
[ ! -x "$(which whiptail)" ] && sudo apt install whiptail -y 1> /dev/null 2>&1 # dialog instalado?

whiptail --title "Instalação do Módulo de Segurança" \
--yesno "Deseja instalar o Módulo de Segurança?" 8 42

# warsaw instalado?
if [ $? -eq 0 ]; then
  [ -x "$(which warsaw)" ] && {
    whiptail --title "Instalação do Módulo de Segurança" \
    --msgbox "Módulo de segurança já está instalado!" --fb 10 42
    menu_pacote=$(whiptail --title "Instalação do Módulo de Segurança" \
    --menu "Selecione uma opção (usar setas e barra de espaço)." 12 40 2 \
      "1" "Exibir informações do pacote" \
      "2" "Remover o pacote" 3>&1 1>&2 2>&3 
    )
    case $menu_pacote in
      1) dpkg -s warsaw > "$TEMP"
         whiptail --title "Módulo de Segurança" --textbox "$TEMP" 20 65 --scrolltext && rm -f "$TEMP"
         clear && exit 0
      ;;  
      2) sudo dpkg -r warsaw && sudo apt autoremove -y && exit 0
      ;;
    esac
    clear && exit 0
  } 
else
  clear && exit 0
fi
# ---------------------------------------------------------------------------------------------------------------------------------------------- #
# -------------------------------------------------------- FUNÇÕES ----------------------------------------------------------------- #
Instalacao () {
  [ ! -x "$(which wget)" ] && sudo apt install wget -y 1> /dev/null 2>&1 # wget instalado?
  wget -c "$SITE"
  [ ! -f "$ARQUIVO" ] && {
  whiptail --title "Erro" --msgbox "Falha no download! Instalação abortada." 10 25 --fb 10 50 && exit 1
  }
  sudo apt update && sudo dpkg -i "$ARQUIVO" && sudo apt -f install -y
  whiptail --title "Instalação Concluída" \
  --msgbox "Por favor, reinicie seu computador para ativar o serviço." 12 30 --fb 10 50
}
# ---------------------------------------------------------------------------------------------------------------------------------------------- #
# -------------------------------------------------------- EXECUÇÃO ---------------------------------------------------------------- #
menu_instalacao=$(whiptail --title "Instalação do Módulo de Segurança" \
--radiolist "Selecione qual módulo você deseja instalar (usar setas, barra de espaço e o TAB)." 14 40 4 \
  "Genérico" "" ON \
  "Banco do Brasil" "" OFF \
  "Caixa Econômica" "" OFF \
  "Banco Itaú" ""  OFF  3>&1 1>&2 2>&3
)
if [ "$(uname -m)" != "x86_64" ]; then
  case $menu_instalacao in
    "Genérico") SITE=${SITE[0]} ARQUIVO=${ARQUIVO[0]}        ;;
    "Banco do Brasil") SITE=${SITE[2]} ARQUIVO=${ARQUIVO[2]} ;;    
    "Caixa Econômica") SITE=${SITE[4]} ARQUIVO=${ARQUIVO[4]} ;;    
    "Banco Itaú") SITE=${SITE[6]} ARQUIVO=${ARQUIVO[6]}      ;;
    *) clear && exit 0                                       ;;
  esac
  Instalacao
else
  case $menu_instalacao in
    "Genérico") SITE=${SITE[1]} ARQUIVO=${ARQUIVO[1]}        ;;
    "Banco do Brasil") SITE=${SITE[3]} ARQUIVO=${ARQUIVO[3]} ;; 
    "Caixa Econômica") SITE=${SITE[5]} ARQUIVO=${ARQUIVO[5]} ;;   
    "Banco Itaú") SITE=${SITE[7]} ARQUIVO=${ARQUIVO[7]}      ;;
    *) clear && exit 0                                       ;;
  esac
  Instalacao
fi  
# ---------------------------------------------------------------------------------------------------------------------------------------------- #
