#!/usr/bin/env bash
#
# install-warsaw-dv1.0.sh - Instala o Módulo de Segurança dos Bancos
#
# Site:     
# Autor:      Flávio Varejão
# Manutenção: Flávio Varejão
# -------------------------------------------------------------------------------------------------------------------------------- #
# Este script irá instalar a última versão do Módulo de Segurança dos Bancos no Linux utilizando O DIALOG (caixas de diálogo).
# Leia as instruções a seguir.
#
# Exemplo:
#   $ ./install-warsaw-dv1.0.sh
#   Neste exemplo o script será executado.
#
# Na seção de variáveis é possível alterar as URLs (em SITE) e o nome do arquivo (em ARQUIVO) 
# caso tenham sofrido alguma mudança no servidor.   
# -------------------------------------------------------------------------------------------------------------------------------- #
# Histórico:
#   v1.0 14/03/2020, Flávio:
#     - Início do programa            
# -------------------------------------------------------------------------------------------------------------------------------- #
# Testado em:
#   bash 4.4.20
# -------------------------------------------------------------------------------------------------------------------------------- #
# ---------------------------------------- VARIÁVEIS-------------------------------------------------- #
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
# -------------------------------------------------------------------------------------------------------------------------------- #
# ----------------------------------------- TESTES --------------------------------------------------- # 
[ ! -x "$(which dialog)" ] && sudo apt install dialog -y 1> /dev/null 2>&1 # dialog instalado?

dialog --title 'Instalação do Módulo de Segurança' \
--yesno 'Deseja instalar o Módulo de Segurança?' 7 45

# warsaw instalado?
if [ $? -eq 0 ]; then
  [ -x "$(which warsaw)" ] && {
    dialog --title 'Instalação do Módulo de Segurança' \
    --infobox 'Módulo de segurança já está instalado!' 3 45; sleep 5 && clear
    dpkg -s warsaw > "$TEMP"
    dialog --title 'Módulo de Segurança' --textbox "$TEMP" 0 0 && rm -f "$TEMP" && clear
  } 
else
  clear && exit 0
fi
# --------------------------------------------------------------------------------------------------------------------------------- #
# ----------------------------------------- FUNÇÕES -------------------------------------------------- #
Instalacao () {
  [ ! -x "$(which wget)" ] && sudo apt install wget -y 1> /dev/null 2>&1 # wget instalado?
  wget -c "$SITE"
  [ ! -f "$ARQUIVO" ] && {
  dialog --title 'Erro' --msgbox 'Falha no download! Instalação abortada.' 5 43 && clear && exit 1
  }
  sudo apt update && sudo dpkg -i "$ARQUIVO" && sudo apt -f install -y
  dialog --title 'Instalação Concluída' \
  --msgbox 'Por favor, reinicie seu computador para ativar o serviço.' 6 50 && clear && exit 0
}
# --------------------------------------------------------------------------------------------------------------------------------- #
# ----------------------------------------- EXECUÇÃO ------------------------------------------------- #
menu=$(dialog --title 'Instalação do Módulo de Segurança' \
--radiolist 'Selecione qual módulo você deseja instalar (usar setas e barra de espaço).' 13 38 5 \
  'Genérico' '' ON \
  'Banco do Brasil' '' OFF \
  'Caixa Econômica' '' OFF \
  'Banco Itaú' '' OFF --stdout
)
if [ "$(uname -m)" != "x86_64" ]; then
  case $menu in
    "Genérico") SITE=${SITE[0]} ARQUIVO=${ARQUIVO[0]}         ;;
    "Banco do Brasil") SITE=${SITE[2]} ARQUIVO=${ARQUIVO[2]}  ;;    
    "Caixa Econômica") SITE=${SITE[4]} ARQUIVO=${ARQUIVO[4]}  ;;    
    "Banco Itaú") SITE=${SITE[6]} ARQUIVO=${ARQUIVO[6]}       ;;
    *) clear && exit 0                                        ;;
  esac
  Instalacao
else
  case $menu in
    "Genérico") SITE=${SITE[1]} ARQUIVO=${ARQUIVO[1]}         ;;
    "Banco do Brasil") SITE=${SITE[3]} ARQUIVO=${ARQUIVO[3]}  ;; 
    "Caixa Econômica") SITE=${SITE[5]} ARQUIVO=${ARQUIVO[5]}  ;;   
    "Banco Itaú") SITE=${SITE[7]} ARQUIVO=${ARQUIVO[7]}       ;;
    *) clear && exit 0                                        ;;
  esac
  Instalacao
fi
# --------------------------------------------------------------------------------------------------------------------------------- #
