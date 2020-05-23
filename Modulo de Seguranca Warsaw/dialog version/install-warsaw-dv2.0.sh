#!/usr/bin/env bash
#
# install-warsaw-dv2.0.sh - Instala o Módulo de Segurança dos Bancos
#
# Site:     
# Autor:      Flávio Varejão
# Manutenção: Flávio Varejão
# -------------------------------------------------------------------------------------------------------------------------------- #
# Este script irá instalar a última versão do Módulo de Segurança dos Bancos no Linux
# utilizando O DIALOG (caixas de diálogo).
#
# O script suporta arquivos deb e rpm, logo é compatível com distros que utilizam o gerenciador 
# de pacotes dpkg, zypper e dnf (Ubuntu, Fedora, OpenSUSE, etc). Leia as instruções a seguir.
#
# Como usar:
#
#   Primeiro acesso (permissão de execução):
#     $ chmod +x install-warsaw-2.0.sh
#
#   Exemplo de uso:
#     $ ./install-warsaw-dv2.0.sh
#     Neste exemplo o script será executado.
#
# Na seção de variáveis é possível alterar as URLs (em SITE) e o nome do arquivo (em ARQUIVO) 
# caso tenham sofrido alguma mudança no servidor.
#
# Obs.: A opção 'Genérico' significa que funciona para todos os bancos (geral), é uma versão tirada do 
# site do desenvolvedor. As outras opções foram tiradas do site dos bancos e podem ter sido modificadas
# pelos bancos por questões de compatibilidade. Na dúvida instale a dos bancos.
# -------------------------------------------------------------------------------------------------------------------------------- #
# Histórico:
#   Versão 1.0, Flávio:
#     14/03/2020
#       - Início do programa
#     11/05/2020
#       - Adicionado a opção de exibir informações do pacote
#       - Adicionado a opção de remover o pacote
#   Versão 2.0, Flávio:
#     23/05/2020
#       - Adicionado suporte a arquivos rpm (zypper e dnf)
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
TEMP=temp.$$
# -------------------------------------------------------------------------------------------------------------------------------- #
# ----------------------------------------- TESTES --------------------------------------------------- # 
# dialog instalado?
[ ! -x "$(which dialog 2> /dev/null)" ] && {
  if [ -x "$(which dpkg 2> /dev/null)" ]; then
    sudo apt install dialog -y 
  elif [ -x "$(which zypper 2> /dev/null)" ]; then
    sudo zypper install -y dialog 
  else
    sudo dnf install -y dialog 
  fi
}

dialog --title 'Instalação do Módulo de Segurança' \
--yesno 'Deseja instalar o Módulo de Segurança?' 7 45

# warsaw instalado?
if [ $? -eq 0 ]; then
  [ -x "$(which warsaw 2> /dev/null)" ] && {
    dialog --title 'Instalação do Módulo de Segurança' \
    --infobox 'Módulo de segurança já está instalado!' 3 45; sleep 1.5
    menu_pacote=$(dialog --title 'Instalação do Módulo de Segurança' \
    --menu 'Selecione uma opção (usar setas e barra de espaço).' 10 38 5 \
      1 'Exibir informações do pacote' \
      2 'Remover o pacote' --stdout 
    )
    if [ -x "$(which dpkg 2> /dev/null)" ]; then
      case $menu_pacote in
        1) dpkg -s warsaw > "$TEMP"
           dialog --title 'Módulo de Segurança' --textbox "$TEMP" 0 0 && rm -f "$TEMP"
           clear && exit 0
        ;;  
        2) clear && sudo dpkg -r warsaw && exit 0
        ;;
      esac
      clear && exit 0
    elif [ -x "$(which zypper 2> /dev/null)" ]; then
      case $menu_pacote in
        1) zypper info warsaw > "$TEMP"
           dialog --title 'Módulo de Segurança' --textbox "$TEMP" 0 0 && rm -f "$TEMP"
           clear && exit 0
        ;;  
        2) clear && sudo zypper remove warsaw && exit 0
        ;;
      esac
      clear && exit 0	
    else
      case $menu_pacote in
        1) dnf info warsaw > "$TEMP"
           dialog --title 'Módulo de Segurança' --textbox "$TEMP" 0 0 && rm -f "$TEMP"
           clear && exit 0
        ;;  
        2) clear && sudo dnf remove warsaw && exit 0
        ;;
      esac
      clear && exit 0
    fi
  } 
else
  clear && exit 0
fi
# --------------------------------------------------------------------------------------------------------------------------------- #
# ----------------------------------------- FUNÇÕES -------------------------------------------------- #
Instalacao_Deb () {
  clear
  [ ! -x "$(which wget)" ] && sudo apt install wget -y # wget instalado?
  wget -c "$SITE"
  [ ! -f "$ARQUIVO" ] && {
  dialog --title 'Erro' --msgbox 'Falha no download! Instalação abortada.' 5 43 && clear && exit 1
  }
  sudo dpkg -i "$ARQUIVO" && sudo apt -f install -y
  dialog --title 'Instalação Concluída' \
  --msgbox 'Por favor, reinicie seu computador para ativar o serviço.' 6 50 && clear && exit 0
}
Instalacao_Rpm_1 () {
  clear
  [ ! -x "$(which wget)" ] && sudo zypper install -y wget # wget instalado?
  wget -c "$SITE"
  [ ! -f "$ARQUIVO" ] && {
  dialog --title 'Erro' --msgbox 'Falha no download! Instalação abortada.' 5 43 && clear && exit 1
  }
  sudo zypper --no-gpg-checks install -y "$ARQUIVO"
  dialog --title 'Instalação Concluída' \
  --msgbox 'Por favor, reinicie seu computador para ativar o serviço.' 6 50 && clear && exit 0
}
Instalacao_Rpm_2 () {
  clear
  [ ! -x "$(which wget)" ] && sudo dnf install -y wget # wget instalado?
  wget -c "$SITE"
  [ ! -f "$ARQUIVO" ] && {
  dialog --title 'Erro' --msgbox 'Falha no download! Instalação abortada.' 5 43 && clear && exit 1
  }
  sudo dnf localinstall -y "$ARQUIVO"
  dialog --title 'Instalação Concluída' \
  --msgbox 'Por favor, reinicie seu computador para ativar o serviço.' 6 50 && clear && exit 0
}
# --------------------------------------------------------------------------------------------------------------------------------- #
# ----------------------------------------- EXECUÇÃO ------------------------------------------------- #
if [ -x "$(which dpkg 2> /dev/null)" ]; then
  menu_instalacao_deb=$(dialog --title 'Instalação do Módulo de Segurança' \
  --radiolist 'Selecione qual módulo você deseja instalar (usar setas e barra de espaço).' 13 38 5 \
    'Genérico' '' ON \
    'Banco do Brasil' '' OFF \
    'Caixa Econômica' '' OFF \
    'Banco Itaú' '' OFF --stdout
  )
  if [ "$(uname -m)" != "x86_64" ]; then
    case $menu_instalacao_deb in
      "Genérico") SITE=${SITE[0]} ARQUIVO=${ARQUIVO[0]}         ;;
      "Banco do Brasil") SITE=${SITE[2]} ARQUIVO=${ARQUIVO[2]}  ;;    
      "Caixa Econômica") SITE=${SITE[4]} ARQUIVO=${ARQUIVO[4]}  ;;    
      "Banco Itaú") SITE=${SITE[6]} ARQUIVO=${ARQUIVO[6]}       ;;
      *) clear && exit 0                                        ;;
    esac
    Instalacao_Deb
  else
    case $menu_instalacao_deb in
      "Genérico") SITE=${SITE[1]} ARQUIVO=${ARQUIVO[1]}         ;;
      "Banco do Brasil") SITE=${SITE[3]} ARQUIVO=${ARQUIVO[3]}  ;; 
      "Caixa Econômica") SITE=${SITE[5]} ARQUIVO=${ARQUIVO[5]}  ;;   
      "Banco Itaú") SITE=${SITE[7]} ARQUIVO=${ARQUIVO[7]}       ;;
      *) clear && exit 0                                        ;;
    esac
    Instalacao_Deb
  fi
elif [ -x "$(which zypper 2> /dev/null)" ]; then
  menu_instalacao_rpm=$(dialog --title 'Instalação do Módulo de Segurança' \
  --radiolist 'Selecione qual módulo você deseja instalar (usar setas e barra de espaço).' 10 38 5 \
    'Genérico' '' ON --stdout
  )
  case $menu_instalacao_rpm in
    "Genérico") SITE=${SITE[10]} ARQUIVO=${ARQUIVO[10]}         ;;
    *) clear && exit 0 ;;                                     
  esac
  Instalacao_Rpm_1
else
  menu_instalacao_rpm=$(dialog --title 'Instalação do Módulo de Segurança' \
  --radiolist 'Selecione qual módulo você deseja instalar (usar setas e barra de espaço).' 10 38 5 \
    'Genérico' '' ON --stdout
  )
  if [ "$(uname -m)" != "x86_64" ]; then
    case $menu_instalacao_rpm in
      "Genérico") SITE=${SITE[8]} ARQUIVO=${ARQUIVO[8]}         ;;
      *) clear && exit 0                                        ;;
    esac
    Instalacao_Rpm_2
  else
    case $menu_instalacao_rpm in
      "Genérico") SITE=${SITE[9]} ARQUIVO=${ARQUIVO[9]}         ;;
      *) clear && exit 0                                        ;;
    esac
    Instalacao_Rpm_2
  fi  
fi 
# --------------------------------------------------------------------------------------------------------------------------------- #
