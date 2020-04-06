#!/usr/bin/env bash
#
# rsync-backup-dv1.0.sh - Backup com a ferramenta rsync
#
# Site:     
# Autor:      Flávio Varejão
# Manutenção: Flávio Varejão
# --------------------------------------------------------------------------------------------------------------------------- #
# Este script faz o backup de arquivos locais ou remotos utilizando a ferramenta rsync 
# Essa versão utiliza caixas de diálogo do DIALOG. Leia as instruções a seguir.
#
# Dê permissão de execução (primeiro acesso):
#   $ chmod +x rsync-backup-dv1.0.sh
#
# Exemplos:
#   $ ./rsync-backup-dv1.0.sh
#   Neste exemplo o script vai perguntar se você deseja fazer um backup.
#
# Na execução do script é possível escolher o diretório de origem e de destino dos arquivos.
# No término do backup é gerado um arquivo log com informações do backup 
# (data, hora, arquivos copiados, etc).
#
# Opções incluídas no comando rsync:
# -u  Envia somente novos arquivos ou modificados;
# -a  Modo de arquivamento (inclui diretórios e mantém os metadados);
# -v  Modo verboso (visualiza o processo);
# -h  Números compreensíveis para humanos;
# -P  Exibe os tempos de transferência, nomes dos arquivos e diretórios sincronizados;
# -z  Comprime os arquivos ou diretórios;
# --progress  Mostra o progresso durante a transferência.
#
# Para incluir novas opções (rsync --help) altere o comando rsync na seção de FUNÇÕES.   
# --------------------------------------------------------------------------------------------------------------------------- #
# Histórico:
#   Versão 1.0, Flávio:
#     25/03/2020
#       - Início do programa
#       - Adicionado variáveis, testes, funções e execução
#     28/03/2020         
#       - Adicionado barras de progresso
# --------------------------------------------------------------------------------------------------------------------------- #
# Testado em:
#   bash 4.4.20 
# --------------------------------------------------------------------------------------------------------------------------- #
# ------------------------------------------------ VARIÁVEIS------------------------------------------------- #
LOG="$(date +%m%Y)"

ARQUIVO_LOG="bkp-$LOG.log"

MENSAGEM_LOG="#$(date "+%A, %d %B %Y")#" 
# --------------------------------------------------------------------------------------------------------------------------- #
# ------------------------------------------------- TESTES -------------------------------------------------- # 
[ ! -x "$(which dialog)" ] && sudo apt install dialog -y 1> /dev/null 2>&1 # dialog instalado?
[ ! -x "$(which rsync)" ] && sudo apt install rsync -y # rsync instalado?
# --------------------------------------------------------------------------------------------------------------------------- #
# ------------------------------------------------- FUNÇÕES ------------------------------------------------- #
Backup_local () {
  dialog --infobox 'Iniciando Backup...' 3 25; sleep 1
  echo "$MENSAGEM_LOG" >> "$ARQUIVO_LOG"
  rsync -avh --progress "$dir_origem" "$dir_destino" --log-file="$ARQUIVO_LOG" \
  | perl -lane 'BEGIN { $/ = "\r"; $|++ } $F[1] =~ /(\d+)%$/ && print $1' \
  | dialog --gauge 'Aguarde... Copiando Arquivos' 8 70 0
  dialog --msgbox 'Backup concluído com sucesso!' 6 35
  dialog --title 'Log de Backup' --textbox "$ARQUIVO_LOG" 0 0
  clear
  exit
}
Backup_remoto () {
  dialog --infobox 'Iniciando Backup...' 3 25; sleep 1
  echo "$MENSAGEM_LOG" >> "$ARQUIVO_LOG"
  sudo rsync -avhP --progress "$dir_origem" "$dir_destino" --log-file="$ARQUIVO_LOG" \
  | perl -lane 'BEGIN { $/ = "\r"; $|++ } $F[1] =~ /(\d+)%$/ && print $1' \
  | dialog --gauge 'Aguarde... Copiando Arquivos' 8 70 0
  dialog --msgbox 'Backup concluído com sucesso!' 6 35
  dialog --title 'Log de Backup' --textbox "$ARQUIVO_LOG" 0 0
  clear
  exit
}
# ---------------------------------------------------------------------------------------------------------------------------- #
# ------------------------------------------------- EXECUÇÃO ------------------------------------------------ #
dialog --title 'Backup com rsync' \
--yesno 'Deseja fazer um Backup?' 6 28

[ $? -eq 0 ] && {
  menu=$(dialog --title 'Backup com rsync' \
  --menu 'Selecione o tipo de Backup' 10 32 2 \
  1 'Backup local' \
  2 'Backup remoto' --stdout
  )
  case "$menu" in
    1) 
      dir_origem=$(dialog --title 'Selecione o arquivo ou diretório' \
      --fselect "$HOME"/ 14 80 --stdout)
      [ $? -eq 0 ] && {
        dir_destino=$(dialog --title 'Selecione o diretório em que será salvo' \
        --dselect "$HOME"/ 14 50 --stdout)
        [ $? -eq 0 ] && {
          Backup_local
        }
        clear && exit 0
      }  
      clear && exit 0
    ;;
    2)
      dir_origem=$(dialog --title 'Selecione o arquivo ou diretório' \
      --fselect "$HOME"/ 14 80 --stdout)
      [ $? -eq 0 ] && {
        dir_destino=$(dialog --title 'Selecione o diretório em que será salvo' \
        --dselect "$HOME"/ 14 50 --stdout)
        [ $? -eq 0 ] && {
          Backup_remoto
        }
        clear && exit 0
      }  
      clear && exit 0
    ;;
  esac
}
clear && exit
# ------------------------------------------------------------------------------------------------------------------------------ #
