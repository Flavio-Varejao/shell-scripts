#!/usr/bin/env bash
#
# rsync-backup.sh - Backup com a ferramenta rsync
#
# Site:     
# Autor:      Flávio Varejão
# Manutenção: Flávio Varejão
# --------------------------------------------------------------------------------------------------------------------------- #
# Este script faz o backup de arquivos locais ou remotos utilizando a ferramenta rsync.
# Leia as instruções a seguir.
#
# Dê permissão de execução (primeiro acesso):
#   $ chmod +x rsync-backup.sh
#
# Como usar:
#   $ ./rsync-backup.sh -l
#   Neste exemplo o script vai executar um backup local.
#
# Na execução do script é possível escolher o diretório de origem e de destino dos arquivos. 
# No término do backup é gerado um arquivo de log com informações do backup 
# (data, hora, arquivos copiados, etc).
#
# Opções incluídas ou sugeridas para o comando rsync:
# -a Agrupa todas essas opções -rlptgoD (recursiva, links, permissões, horários, grupo, proprietário, dispositivos);
# -v Modo verboso (mostra o processo);
# -h Números compreensíveis para humanos;
# -P Exibe os tempos de transferência, nomes dos arquivos e diretórios sincronizados;
# -z Comprime os arquivos ou diretórios;
# -e ssh Utiliza o protocolo de rede SSH;
# --delete-after Após a transferência exclui arquivos do destino que não estão na origem (sincroniza os diretórios);
# --progress Mostra o progresso durante a transferência.
#
# Para incluir novas opções veja em 'rsync --help' altere o comando rsync na seção de FUNÇÕES.
# --------------------------------------------------------------------------------------------------------------------------- #
# Histórico:
#   Versão 1.0, Flávio:
#     17/03/2020
#       - Início do programa.
#       - Adicionado variáveis, testes, funções e execução.
#     28/03/2020         
#       - Adicionado tratamento de erros (função Verifica_status).
#   Versão 2.0, Flávio:
#     29/07/2020
#       - Alterações no cabeçalho do script e no comando do backup remoto.
# --------------------------------------------------------------------------------------------------------------------------- #
# Testado em:
#   bash 4.4.20 
# --------------------------------------------------------------------------------------------------------------------------- #
# ------------------------------------------------ VARIÁVEIS------------------------------------------------- #
VERDE="\033[32;1m"
AMARELO="\033[33;1m"
VERMELHO="\033[31;1m"

LOG="$(date +%m%Y)"

ARQUIVO_LOG="bkp-$LOG.log"

MENU="
  $0 [-OPÇÃO]
    
    -l  Backup local
    -r  Backup remoto
"
MENSAGEM_LOG="#$(date "+%A, %d %B %Y")#" 
# --------------------------------------------------------------------------------------------------------------------------- #
# ------------------------------------------------- TESTES -------------------------------------------------- # 
[ ! -x "$(which rsync)" ] && sudo apt install rsync -y # rsync instalado?
# --------------------------------------------------------------------------------------------------------------------------- #
# ------------------------------------------------- FUNÇÕES ------------------------------------------------- #
Backup_local () {
  clear && echo -e "${AMARELO}Backup local \n" && tput sgr0
  echo "$MENSAGEM_LOG" >> "$ARQUIVO_LOG"
  rsync -avh --progress "$dir_origem" "$dir_destino" --log-file="$ARQUIVO_LOG" # Alterar as opções se necessário
  Verifica_status
}
Backup_remoto () {
  clear && echo -e "${AMARELO}Backup remoto \n" && tput sgr0
  echo "$MENSAGEM_LOG" >> "$ARQUIVO_LOG"
  sudo rsync -avhP --progress -e ssh "$dir_origem" "$dir_destino" --log-file="$ARQUIVO_LOG" # Alterar as opções se necessário
  Verifica_status
}
Verifica_status () {
  tail -1 "$ARQUIVO_LOG" | grep "rsync error" 
  if [ ! $? -eq 0 ]; then
    echo -e "\n${VERDE}Backup concluído com sucesso. \n" && tput sgr0 && exit 0
  else
    echo -e "\n${VERMELHO}Backup concluído com erros. Erros mais comuns: \n
    - Nome do arquivo e/ou diretório incorretos
    - Arquivos ou diretório inexistentes
    - Diretório está vazio 
    - Nomes compostos sem * entre as palavras. Ex: /Área*de*Trabalho
    " && tput sgr0 && exit 1
  fi
}   
# --------------------------------------------------------------------------------------------------------------------------- #
# ------------------------------------------------- EXECUÇÃO ------------------------------------------------ #
echo -e "\n Backup com rsync \n $MENU" 
while test -n "$1"; do
  case "$1" in
    -l)
        clear && echo -e "${AMARELO}Backup local \n" && tput sgr0
        read -rp "Informe a origem: " dir_origem                          #Exemplo: /home/user/nome*composto
        echo -e "\nOs arquivos serão salvos em /home/$USER/Backup/ \n"
        echo "Deseja manter esse diretório de destino? [s/n] "
        read -rn1 resposta && echo ""
        case "$resposta" in
          S | s) dir_destino="/home/$USER/Backup/" && Backup_local ;; 
          N | n) read -rp "Digite o diretório de destino: " dir_destino && Backup_local ;; 
              *) echo "Processo abortado." && exit 1 ;;
        esac
    ;;
    -r) 
        clear && echo -e "${AMARELO}Backup remoto \n" && tput sgr0
        read -rp "Digite a origem (Exemplo:/home/$USER/Backup/): " dir_origem && echo ""  
        read -rp "Digite o destino (Exemplo: username@xxx.xxx.xxx:~/destino): " dir_destino && echo ""
        Backup_remoto
    ;;
     *) echo -e "${VERMELHO}Opção inválida. Digite $0 [-OPÇÃO] \n" && tput sgr0
        exit 1
    ;;
  esac
done
# --------------------------------------------------------------------------------------------------------------------------- #
