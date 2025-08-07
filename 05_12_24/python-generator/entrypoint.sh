#!/bin/bash

echo "🚀 Iniciando generación de datos..."

# Ejecutar el script de Python
python generate_data.py

# Copiar el archivo generado al directorio raíz compartido
echo "📋 Copiando archivo a PostgreSQL..."
cp /app/output/1_inserts.sql /app/output/../1_inserts.sql

echo "✅ Proceso completado"