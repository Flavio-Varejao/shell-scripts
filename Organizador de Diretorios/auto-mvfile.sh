#!/usr/bin/env bash
#
# mvfile.sh - Organizador Automático de Diretório
#
# Site:     
# Autor:      Flávio Varejão
# Manutenção: Flávio Varejão
# -------------------------------------------------------------------------------------------------------------------------- #
# Este script organiza o diretório de Downloads automaticamente de acordo com o tipo de arquivo.
# Os arquivos serão movidos para os diretórios predeterminados pelo usuário.
#
# Este script será utilizado no agendador de tarefas crontab e o tempo de execução será configurado pelo usuário.
#
# Se desejar altere os diretórios abaixo ou acrescente mais arquivos ao script.
# -------------------------------------------------------------------------------------------------------------------------- #
# Histórico:
#   v1.0 09/09/2020, Flávio:
#     - Início do programa            
# -------------------------------------------------------------------------------------------------------------------------- #
# Testado em:
#   bash 5.0.17 
# -------------------------------------------------------------------------------------------------------------------------- #
# ------------------------------------------------- FUNÇÕES ------------------------------------------------- #
Imagens() {
  mv *.png *.jpg ./Imagens 2> /dev/null
}

Multimidia() {
  mv *.mp4 *.mkv *.mp3 *.ogg ./Multimidia 2> /dev/null
}

Documentos() {
  mv *.pdf *.docx *.pptx *.doc *.xlsx *.txt *.sh ./Documentos 2> /dev/null
}

Pacotes() {
  mv *.deb *.run *.zip *.tar.xz ./Pacotes 2> /dev/null
}

Imagem_Disco() {
  mv *.iso ./Distros 2> /dev/null
}
# -------------------------------------------------------------------------------------------------------------------------- #
# ------------------------------------------------- EXECUÇÃO ------------------------------------------------ #
cd $HOME/Downloads/

#Imagens
[ "*.png" -o "*.jpg" ] && Imagens

#Multimidia
[ "*.mp4" -o "*.mkv" -o "*.mp3" -o "*.ogg" ] && Multimidia

#Documentos
[ "*.pdf" -o "*.docx" -o "*.pptx" -o "*.doc" -o "*.xlsx" -o "*.txt" -o "*.sh" ] && Documentos

#Pacotes
[ "*.deb" -o "*.run" -o "*.zip" -o "*.tar.xz" ] && Pacotes

#Imagem de disco
[ "*.iso" ] && Imagem_Disco
# -------------------------------------------------------------------------------------------------------------------------- #
