# ------------------------------
#AUTOR : LORENZO TOLEDO GABRIEL
# ------------------------------
# Imagen basede Python 
FROM python:3.11-slim
# CreaMOs el usuario no root por seguridad desde i punto de vista
# ------------------------------
RUN useradd -m appuser
# Creamos la carpeta de trabajo
# ------------------------------
WORKDIR /app
# Copiamos e instalamos dependencias
# ------------------------------
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
# Copiamos el resto del proyecto
# ------------------------------
COPY . .
# Cambiamos a usuario no root
# ------------------------------
USER appuser
# Variables de entorno
# ------------------------------
ENV PYTHONUNBUFFERED=1
ENV DJANGO_SETTINGS_MODULE=demo.settings
ENV PORT=8000
# puerto de la app por defecto
# ------------------------------
EXPOSE 8000
# AGREGAmos un chekeo de salud del contenedor
# ------------------------------
HEALTHCHECK --interval=30s --timeout=5s --retries=3 \
  CMD curl -f http://localhost:8000/ || exit 1
# dejamos por defecto  correr Django
# ------------------------------
CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]
