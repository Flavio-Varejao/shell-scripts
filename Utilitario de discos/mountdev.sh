#!/usr/bin/env bash
#
# mountdev.sh - Utilitário para dispositivos de armazenamento
#
# Site:     
# Autor:      Flávio Varejão
# Manutenção: Flávio Varejão
# -------------------------------------------------------------------------------------------------------------------------- #
# Este script formata e/ou grava uma imagem USB em um dispositivo de armazenamento externo.
# Leia o que se segue.
#
# Como usar:
#
#   Primeiro acesso (permissão de execução):
#     $ chmod +x mountdev.sh
#
#   Exemplo:
#     $ ./mountdev.sh -f
#     Neste exemplo o script vai formatar o seu dispositivo
#
# O script identifica se o dispositivo está montado, se estiver montado ele
# abre um menu com as opções. No processo de formatar é possível 
# selecionar entre FAT32, NTFS e EXT4.
#
# ATENÇÃO!
# ESTE SCRIPT IDENTIFICA O DISPOSITIVO DE ARMAZENAMENTO MONTADO NA PORTA USB.
# MAS NÃO FOI TESTADO EM UMA MÁQUINA COM MAIS DE 1 DISPOSITIVO DE ARMAZENAMENTO USB.
# LOGO, DEVIDO A ESSA LIMITAÇÃO, O SCRIPT ESTÁ INCOMPLETO E PRECISA SER APERFEIÇOADO.
# VERIFIQUE O DIRETÓRIO DO PENDRIVE OU HD EXTERNO. NÃO ME RESPONSABILIZO POR PERDAS DE DADOS!
# -------------------------------------------------------------------------------------------------------------------------- #
# Histórico:
#   v1.0 09/06/2020, Flávio:
#     - Adicionado variáveis, comandos de testes, funções e execução.          
# -------------------------------------------------------------------------------------------------------------------------- #
# Testado em:
#   bash 4.4.20 
# -------------------------------------------------------------------------------------------------------------------------- #
# ------------------------------------------------ VARIÁVEIS------------------------------------------------- #
VERSAO="mountDEV Versão 1.0
"
VERDE="\033[32;1m"
AMARELO="\033[33;1m"
VERMELHO="\033[31;1m"

MENU_PRINCIPAL=" 
 $0 [-OPÇÃO]

   -f  Formatar dispositivo
   -w  Gravar imagem USB
   -V  Versão do programa
   -h  Ajuda
"
MENU_TIPO="

   1 FAT32 | 2 NTFS | 3 EXT4
"
AJUDA="
    $0 [-h ] [--help]
    
        -f Apaga os dados (formata) do dispositivo de armazenamento
        -w Grava uma imagem de inicialização no dispositivo de armazenamento
        -h Exibe este menu de ajuda e sai
        -V Exibe a versão deste programa e sai 
"
# -------------------------------------------------------------------------------------------------------------------------- #
# ------------------------------------------------- TESTES -------------------------------------------------- # 
# Dispositivo montado?
mount | grep -q "media"
if [ ! $? -eq 0 ]; then
  echo -e "${AMARELO}\nNão há um dispositivo montado!\n"
  exit 1
else
  DEV="$(mount | grep "media" | cut -c1-8)" #<-- Precisa ser aperfeiçoado
fi  
# -------------------------------------------------------------------------------------------------------------------------- #
# ------------------------------------------------- FUNÇÕES ------------------------------------------------- #
Formatar () {
  echo -e "\nIniciando a formatação...\n"
  sudo umount "$DEV"
  if [ "$TIPO" = "vfat" ]; then
    sudo mkfs."$TIPO" -I "$DEV" -n "$LABEL"
  elif [ "$TIPO" = "ntfs" ]; then
    sudo mkfs."$TIPO" -F -f -L "$LABEL" "$DEV"
  elif [ "$TIPO" = "ext4" ]; then
    sudo mkfs."$TIPO" -F -L "$LABEL" "$DEV"
  fi
  Verifica_staus
}
Gravar () {
  echo -e "\nGravando no disco...\n"
  sudo dd bs=4096 if="$DIR" of="$DEV" status=progress
  Verifica_staus
}
Verifica_staus () {
  if [ $? -eq 0 ]; then
    echo -e "\n${VERDE}Processo concluído com sucesso. \n" && tput sgr0
    exit 0
  else
    echo -e "\n${VERMELHO}Processo concluído com erros. \n" && tput sgr0
    exit 1
  fi
}
# -------------------------------------------------------------------------------------------------------------------------- #
# ------------------------------------------------- EXECUÇÃO ------------------------------------------------ #
echo -e "\nmountDEV \n"
echo -e "Selecione uma opção:\n $MENU_PRINCIPAL"
while [ -n "$1" ]; do
  case "$1" in
    -f) clear && echo -e "${AMARELO}\nFormatação do dispositivo\n" && tput sgr0
        echo -e "Selecione o tipo do sistema de arquivos $MENU_TIPO"
        echo -ne "Digite o número: "; read -rn1 resposta
        echo -e "\n"
        case "$resposta" in
           1) TIPO="vfat"
              echo -e "File System FAT32\n"
           ;;
           2) TIPO="ntfs" 
              echo -e "File System NTFS\n"
           ;;
           3) TIPO="ext4" 
              echo -e "File System EXT4\n"
           ;;
           *) continue ;;
        esac
        read -rp "Informe um nome para o dispositivo (prefira letras maiúsculas): " LABEL 
        Formatar
     ;;
    -w) clear && echo -e "${AMARELO}\nGravação de Imagem USB\n" && tput sgr0
        echo -e "Digite o diretório da imagem USB: \n"; read -r DIR
        Gravar
     ;;
    -h | --help) echo -e "${AMARELO}$AJUDA" && exit 0 
     ;;
    -V | --version) echo "$VERSAO" && exit 0
     ;;
     *) echo -e "${VERMELHO}Opção inválida, selecione uma opção válida! \n" && tput sgr0 && exit 1 ;;
  esac
  exit 0
done      
# -------------------------------------------------------------------------------------------------------------------------- #
