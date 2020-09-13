#!/usr/bin/env bash
#
# install-warsaw-zv1.0.sh - Instala o Módulo de Segurança dos Bancos
#
# Site:     
# Autor:      Flávio Varejão
# Manutenção: Flávio Varejão
# ------------------------------------------------------------------------------------------------------------------------------ #
# Este script irá instalar a última versão do Módulo de Segurança dos Bancos no Linux utilizando o ZENITY (caixas de diálogo).
# Leia as instruções a seguir.
#
# Exemplo:
#   $ ./install-warsaw-zv1.0.sh
#   Neste exemplo o script será executado.
#
# Na seção de variáveis é possível alterar as URLs (em SITE) e o nome do arquivo (em ARQUIVO) 
# caso tenham sofrido alguma mudança no servidor.   
# ------------------------------------------------------------------------------------------------------------------------------ #
# Histórico:
#   Versão 1.0, Flávio: 
#     13/03/2020
#       - Início do programa
#     16/05/2020
#       - Adicionado a opção de exibir informações do pacote
#       - Adicionado a opção de remover o pacote
# ------------------------------------------------------------------------------------------------------------------------------ #
# Testado em:
#   bash 4.4.20
# ------------------------------------------------------------------------------------------------------------------------------ #
# -------------------------------------------- VARIÁVEIS------------------------------------------------ #
SITE=(
  "https://cloud.gastecnologia.com.br/gas/diagnostico/warsaw_setup_32.deb" \
  "https://cloud.gastecnologia.com.br/gas/diagnostico/warsaw_setup_64.deb" \
  "https://cloud.gastecnologia.com.br/bb/downloads/ws/warsaw_setup.deb" \
  "https://cloud.gastecnologia.com.br/bb/downloads/ws/warsaw_setup64.deb" \
  "https://cloud.gastecnologia.com.br/cef/warsaw/install/GBPCEFwr32.deb" \
  "https://cloud.gastecnologia.com.br/cef/warsaw/install/GBPCEFwr64.deb" \
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
# ------------------------------------------------------------------------------------------------------------------------------ #
# --------------------------------------------- TESTES ------------------------------------------------------- # 
[ ! -x "$(which zenity)" ] && sudo apt install zenity -y 1> /dev/null 2>&1 # zenity instalado?

zenity --question --title "Instalação do Módulo de Segurança" \
--text="Deseja instalar o Módulo de Segurança?" --width="280"

# warsaw instalado?
if [ $? -eq 0 ]; then
  [ -x "$(which warsaw)" ] && {
    zenity --info --title "Instalação do Módulo de Segurança" \
    --text="Módulo de segurança já está instalado!" --width="280"
    menu_pacote=$(zenity --title "Instalação do Módulo de Segurança" \
    --list --column "Módulo de Segurança Warsaw" \
      "Exibir informações do pacote" "Remover o pacote" --width="350" --height="180"
    )  
    case $menu_pacote in
      "Exibir informações do pacote") clear && dpkg -s warsaw && exit 0
      ;;  
      "Remover o pacote") sudo dpkg -r warsaw && sudo apt autoremove -y && exit 0
      ;;
    esac
    clear && exit 0
  } 
else
  clear && exit 0
fi
# ------------------------------------------------------------------------------------------------------------------------------- #
# --------------------------------------------- FUNÇÕES ----------------------------------------------------- #
Instalacao () {
  [ ! -x "$(which wget)" ] && sudo apt install wget -y 1> /dev/null 2>&1 # wget instalado?
  wget -c "$SITE"
  [ ! -f "$ARQUIVO" ] && {
  zenity --error --text="Falha no download! Instalação abortada." --width="220" && exit 1 
  }
  sudo apt update && sudo dpkg -i "$ARQUIVO" && sudo apt -f install -y
  zenity --info --title "Instalação Concluída" \
  --text="Por favor, reinicie seu computador para ativar o serviço." --width="250" && exit 0
}
# ------------------------------------------------------------------------------------------------------------------------------ #
# --------------------------------------------- EXECUÇÃO ---------------------------------------------------- #
menu_instalacao=$(zenity --list --title "Instalação do Módulo de Segurança" \
  --text="Selecione qual módulo você deseja instalar" \
  --radiolist \
  --column "Marcar" \
  --column "Módulo de Segurança" \
  TRUE "Genérico" FALSE "Banco do Brasil" FALSE "Caixa Econômica" FALSE "Banco Itaú" --width="350" --height="215"
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
# ------------------------------------------------------------------------------------------------------------------------------- #
