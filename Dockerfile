# ------------------------------
# AUTOR: LORENZO TOLEDO GABRIEL
# Dockerfile para Django con SQLite
# ------------------------------

FROM python:3.11-slim

WORKDIR /app

# Crear carpeta para la base de datos
RUN mkdir -p db

# Copiar e instalar dependencias
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copiar el resto del proyecto
COPY . .

# Variables de entorno
ENV PYTHONUNBUFFERED=1
ENV DJANGO_SETTINGS_MODULE=demo.settings
ENV PORT=8000

# Exponer el puerto de la app
EXPOSE 8000

# Healthcheck del contenedor
HEALTHCHECK --interval=30s --timeout=5s --retries=3 \
  CMD curl -f http://localhost:8000/ || exit 1

# Comando por defecto para correr Django
CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]
