#!/bin/bash

# Data atual
DATE=$(date +'%Y-%m-%d')

# Caminho para o backup
BACKUP_PATH="dremio_backup_$DATE.tar.gz"

# Diretório temporário para armazenar os dados
TEMP_DIR="./dremio_backup"

# Verificar se o diretório temporário existe e criar se necessário
if [ ! -d "$TEMP_DIR" ]; then
  mkdir -p "$TEMP_DIR"
fi

# Copiar os dados do contêiner Dremio
docker cp dremio:/opt/dremio/data $TEMP_DIR

# Compactar o backup, removendo o prefixo do diretório temporário
tar czf $BACKUP_PATH -C $TEMP_DIR data

# Remover o diretório temporário
rm -rf $TEMP_DIR

# Exibir mensagem de sucesso
echo "Backup criado com sucesso: $BACKUP_PATH"
