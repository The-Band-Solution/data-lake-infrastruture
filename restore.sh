#!/bin/bash

# Verificar se o nome do arquivo de backup foi fornecido como argumento
if [ -z "$1" ]; then
  echo "Uso: $0 <caminho_do_arquivo_de_backup>"
  exit 1
fi

# Caminho para o backup fornecido como argumento
BACKUP_PATH="$1"

# Diretório temporário para descompactar o backup
TEMP_DIR="./dremio_restore"

# Verificar se o arquivo de backup existe
if [ ! -f "$BACKUP_PATH" ]; then
  echo "Arquivo de backup não encontrado: $BACKUP_PATH"
  exit 1
fi

# Verificar se o diretório temporário existe e criar se necessário
if [ ! -d "$TEMP_DIR" ]; then
  mkdir -p "$TEMP_DIR"
fi

# Descompactar o backup no diretório temporário
tar xzf $BACKUP_PATH -C $TEMP_DIR

# Parar o contêiner Dremio antes de restaurar os dados
docker stop dremio

# Copiar os dados de volta para o contêiner Dremio
docker cp $TEMP_DIR/data dremio:/opt/dremio/

# Reiniciar o contêiner Dremio
docker start dremio

# Remover o diretório temporário
rm -rf $TEMP_DIR

# Exibir mensagem de sucesso
echo "Backup restaurado com sucesso a partir de: $BACKUP_PATH"
