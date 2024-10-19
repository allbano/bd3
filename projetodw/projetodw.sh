#!/usr/bin/env bash

# ------------------------------------------------------------------------------- # 
# Script      : projetodw.sh
# Description : 
# Version     : 0.1
# Author      : Albano Roberto Drescher Von Maywitz 
# Data        : 17 de outubro de 2024
# ------------------------------------------------------------------------------- # 
# Use : 
# ------------------------------------------------------------------------------- # 
# Copyright (C) 2024, Albano <allbano@gmail.com>.
# License GPLv3+: GNU GPL version 3 or later <https://gnu.org/licenses/gpl.html>.
# This is free software: you are free to change and redistribute it.
# There is NO WARRANTY, to the extent permitted by law.
# ------------------------------------------------------------------------------- #  


set -e
# Executa o arquivo init.sql usando psql
psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" -f "/tmp/projetodw-full.sql"

# Executa o comando original do entrypoint do PostgreSQL
exec "$@"
