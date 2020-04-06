#!/usr/bin/env bash
#
# rclone-sync.sh - Sincronização de arquivos na nuvem com rclone
#
# Site:     
# Autor:      Flávio Varejão
# Manutenção: Flávio Varejão
# -------------------------------------------------------------------------------------------------------------------------- #
# Este script reúne as opções e comandos mais utilizados na ferramenta rclone.
# Configurar, sincronizar, listar arquivos, verificar, exibir informações, exibir
# o manual, etc. Também é possível agendar sincronizações com a ferramenta
# crontab. Leia as instruções a seguir.
# 
# Dê permissão de execução (primeiro acesso):
#   $ ./chmod +x rclone-sync.sh
#
# Exemplos de uso:
#   $ ./rclone-sync.sh -s
#   Neste exemplo o script vai realizar a sincronização de arquivos na nuvem
#
# Na seção de variáveis você deve digitar o seu DIR_ORIGEM e DIR_DESTINO
# O DIR_ORIGEM é o diretório da máquina local/nuvem
# O DIR_DESTINO é o diretório da nuvem/máquina local
#
# A SINCRONIZAÇÃO SÓ VAI SER POSSÍVEL SE O RCLONE ESTIVER CONFIGURADO PARA O 
# SERVIÇO REMOTO (google drive, dropbox, onedrive, etc).
#
# Para configurar inicie este script com a opção -c
#   $ ./rclone-sync.sh -c
# 
# Dúvidas? Consulte o manual do rclone com o comando:
#   $ ./rclone-sync.sh -m
#
# Para mais informações visite o website:
#   https://rclone.org/docs
# -------------------------------------------------------------------------------------------------------------------------- #
# Histórico:
#   Versão 1.0, Flávio:
#     31/03/2020
#       - Início do programa
#       - Adicionado variáveis, testes, funções e execução
#     01/04/2020         
#       - Adicionado novas funções e menu de ajuda
#     02/04/2020
#       - Adicionado tratamento de erros (função Verifica_status)
# -------------------------------------------------------------------------------------------------------------------------- #
# Testado em:
#   bash 4.4.20 
# -------------------------------------------------------------------------------------------------------------------------- #
# ------------------------------------------------ VARIÁVEIS------------------------------------------------- #
# Altere aqui para o seu serviço remoto. O padrão é o sincronismo da máquina para nuvem.
# Inverta os diretórios se você costuma sincronizar da nuvem para sua máquina:
DIR_ORIGEM="/home/$USER/google-drive/" #<-- Alterar aqui
DIR_DESTINO="mydrive:/"                #<-- Alterar aqui

VERDE="\033[32;1m"
AMARELO="\033[33;1m"
VERMELHO="\033[31;1m"

LOG="$(date +%m%Y)"
ARQUIVO_LOG="rcl-$LOG.log"
MENSAGEM_LOG="#$(date "+%A, %d %B %Y")#" 

MENU="
  $0 [-OPÇÃO]
    
    -s  Sincronizar
    -l  Listar arquivos
    -v  Verificar arquivos
    -i  Informações de armazenamento
    -a  Agendar sincronização
    -m  Ver o manual do rclone
    -c  Configurar o rclone
    -h  Ajuda deste menu
"
AJUDA="
    $0 [-h] [--help]
    
        -s  Sincroniza os arquivos da nuvem <---> máquina local
        -l  Lista os arquivos e diretórios da nuvem
        -v  Verifica diferenças entra a nuvem e a máquina local
        -i  Exibe informações de armazenamento da nuvem (espaço total, usado, livre)
        -a  Agenda sincronizações com a ferramenta crontab
        -m  Exibe o manual do rclone
        -c  Configura o rclone para a nuvem
        -h, --help  Exibe esta tela de ajuda e sai
"
# -------------------------------------------------------------------------------------------------------------------------- #
# ------------------------------------------------- TESTES -------------------------------------------------- # 
[ ! -x "$(which rclone)" ] && curl https://rclone.org/install.sh | sudo bash #rclone instalado?
# -------------------------------------------------------------------------------------------------------------------------- #
# ------------------------------------------------- FUNÇÕES ------------------------------------------------- #
Agendar () { crontab -e && exit; }

Configurar () { rclone config && clear && exit; }

Informacao () { rclone about "$DIR_DESTINO" && exit; }

Listar () { rclone tree "$DIR_DESTINO" && exit; }

Manual () { man rclone && exit; }

Verificar () { 
  rclone check "$DIR_ORIGEM" "$DIR_DESTINO" 
  exit
}
Sincronizar () { 
  echo "$MENSAGEM_LOG" >> "$ARQUIVO_LOG"
  rclone -vP sync --progress "$DIR_ORIGEM" "$DIR_DESTINO" --log-file="$ARQUIVO_LOG"
  Verifica_status
}
Verifica_status () {
  tail "$ARQUIVO_LOG" | grep "ERROR" 
  if [ ! $? -eq 0 ]; then
    echo -e "\n${VERDE}Sincronismo concluído com sucesso. \n" && tput sgr0 && exit 0
  else
    echo -e "\n${VERMELHO}Erros encontrados. Verifique o arquivo $ARQUIVO_LOG. \n
    " && tput sgr0 && exit 1
  fi
}
# -------------------------------------------------------------------------------------------------------------------------- #
# ------------------------------------------------- EXECUÇÃO ------------------------------------------------ #
echo -e "\n Sincronização com rclone \n $MENU"
while [ -n "$1" ] ; do
  case "$1" in
    -a) clear && echo -e "${AMARELO}Agendamento da sincronização \n" && tput sgr0
        Agendar
     ;; 
    -c) clear && echo -e "${AMARELO}Configuração do rclone \n" && tput sgr0
        Configurar
     ;;
    -h | --help) echo -e "${AMARELO}$AJUDA \n" && tput sgr0 && exit 0        
     ;;  
    -i) clear && echo -e "${AMARELO}Informações de armazenamento \n" && tput sgr0
        Informacao
     ;;  
    -l) clear && echo -e "${AMARELO}Listar arquivos e diretórios \n" && tput sgr0
        Listar
     ;;
    -m) clear && Manual
     ;;
    -s) clear && echo -e "${AMARELO}Sincronizar na nuvem \n" && tput sgr0
        Sincronizar
     ;;
    -v) clear && echo -e "${AMARELO}Verificação de arquivos \n" && tput sgr0
        Verificar     
     ;;    
     *) echo -e "${VERMELHO}Opção inválida. Digite $0 [-OPÇÃO] \n" && tput sgr0
        exit 1
     ;;   
  esac
done  
# -------------------------------------------------------------------------------------------------------------------------- #
