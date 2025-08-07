FROM python:3.11-slim

WORKDIR /app

# Instalar dependencias
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copiar el script generador y entrypoint
COPY generate_data.py .
COPY entrypoint.sh .

# Hacer el entrypoint ejecutable
RUN chmod +x entrypoint.sh

# Crear directorio de salida
RUN mkdir -p /app/output

# Ejecutar el entrypoint al iniciar el contenedor
CMD ["./entrypoint.sh"]