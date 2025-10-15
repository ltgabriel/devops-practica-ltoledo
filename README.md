# Ejercicio práctico de DevOps 

**Autor:** Lorenzo Toledo Gabriel  
**Práctico:** devsu-devops-python  
**Tecnologías:** Django 4.2, Python 3.10.9, Docker 28.5.1, Kubernetes (Kind v1.37.0, kubectl v1.34.1), GitHub Actions

# Demo DevOps Python

Aplicación para la prueba técnica de **DevOps-devsu**, desarrollada con **Django 4.2** y **Python 3.10.9**, dockerizada y desplegada en **Kubernetes (Kind)**.

El proyecto incluye un pipeline  que:

- Compila el código
- Ejecuta pruebas unitarias
- Ejecuta análisis de código estático (lint con flake8)
- Genera cobertura de código
- Construye y sube la imagen Docker
- Escanea vulnerabilidades con Trivy
- Despliega la aplicación en un cluster Kind con 2 réplicas
- Configura secretos y variables de entorno
- Realiza comprobación de estado de pods

---

## Primeros pasos

### Requisitos previos

- Python 3.10.9
- Django 4.2
- Docker 28.5.1
- Kubernetes (kubectl v1.34.1, Minikube v1.37.0)
- Git 2.51

### Instalación

Clonar este repositorio:

```bash
git clone https://github.com/ltgabriel/devops-practica-ltoledo.git
cd devops-practica-ltoledo
```
Instalar dependencias:

```bash
pip install -r requirements.txt
```

Migrar la base de datos:
```bash
py manage.py makemigrations
py manage.py migrate
```
### Base de datos

La base de datos se genera como un archivo SQLite en la ruta principal al ejecutar el proyecto por primera vez; su nombre es db.sqlite3.

Se recomienda otorgar permisos de acceso al archivo para su correcto funcionamiento.
En el pipeline CI/CD se utiliza la ruta temporal /tmp/db.sqlite3 para las pruebas automáticas.

### Uso

Para ejecutar pruebas unitarias:
```bash
py manage.py test
```

Para ejecutar la aplicación localmente:
```bash
py manage.py runserver
```

Abrir en el navegador: http://localhost:8000/api/

Endpoints y pruebas de la API
### Características

Estos servicios pueden realizar:
#### Crear usuario
```bash
POST /api/users/
```
```json
{
  "dni": "12345678",
  "name": "Juan Perez"
}
```

Respuesta exitosa (HTTP 200):
```json
{
  "id": 1,
  "dni": "12345678",
  "name": "Juan Perez"
}
```

Error (HTTP 400):
```json
{
  "detail": "error"
}
```
#### Obtener todos los usuarios
```bash
Método: GET
GET /api/users/
```
Respuesta exitosa (HTTP 200):
```json
[
  {
    "id": 1,
    "dni": "12345678",
    "name": "Juan Perez"
  }
]
```
#### Obtener usuario por ID
```bash
Método: GET
GET /api/users/<id>
```
Respuesta exitosa (HTTP 200):
```json
{
  "id": 1,
  "dni": "12345678",
  "name": "Juan Perez"
}
```

Usuario no encontrado (HTTP 404):
```json
{
  "detail": "No encontrado."
}
```
#### Pipeline CI/CD

El pipeline está definido en .github/workflows/pipeline.yaml y contiene 3 jobs principales:

#### Build & Test

Checkout del código
Instalación de dependencias
Migración de base de datos en CI (/tmp/db.sqlite3)
Ejecución de pruebas unitarias y cobertura de código
Linter con flake8

#### Docker Build & Push
Construcción de imagen Docker (devops-django:latest)
Login y push a Docker Hub
Escaneo de vulnerabilidades con Trivy

#### Deploy a Kubernetes (Kind)
Setup de cluster Kind temporal
Despliegue de aplicación con 2 réplicas
Exposición de servicio vía NodePort
Comprobación de estado de pods
Uso de ConfigMaps y Secretos

#### Diagrama del pipeline CI/CD

       GitHub Actions        
     Disparador: push/main   
             │       
        Compilar y    
        Probar        
        - Instalar deps
        - Migraciones 
        - Pruebas unit
        - Linter      
        - Cobertura   
              │
        Construir     
        Imagen Docker 
        - Construir   
        - Subir       
        - Escanear    
              │
        Desplegar en   
        Kubernetes     
        - Configurar   
          cluster Kind 
        - Aplicar      
        - Exponer      
        - Comprobar    
          Pods         
       
#### Despliegue en Kubernetes (Kind)
Se utiliza un cluster local Kind con 2 réplicas de la aplicación.
Se crean Deployments y Services de tipo NodePort.
Configuración de Variables de entorno y Secretos a través de ConfigMaps.
Comprobación de que los pods estén en estado Ready.
Escalamiento horizontal posible mediante:
```bash
kubectl scale deployment devops-django --replicas=N
```
#### Buenas prácticas aplicadas
Variables de entorno para secretos y configuración sensible.
Separación de entornos locales y CI.
Linter y cobertura de código para mantener calidad.
Dockerfile optimizado para reproducibilidad.
Escaneo de vulnerabilidades de la imagen.
Kubernetes configurado con al menos 2 réplicas para escalabilidad horizontal.
Pipeline reproducible y modular.
Documentación clara y ejemplos de pruebas de endpoints.
Uso de rutas temporales en CI para evitar interferencia con DB local.

#### Licencia
Copyright © 2023 Devsu. Todos los derechos reservados.