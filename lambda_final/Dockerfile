# Usa la imagen base oficial de AWS Lambda con Python 3.11
FROM public.ecr.aws/lambda/python:3.11

# Establecer directorio de trabajo
WORKDIR ${LAMBDA_TASK_ROOT}

# Copiar primero requirements.txt (para aprovechar caché de Docker)
COPY requirements.txt ${LAMBDA_TASK_ROOT}

# Instalar dependencias
RUN pip install -r requirements.txt

# Copiar el resto de la aplicación
COPY main.py ${LAMBDA_TASK_ROOT}

# Indicar el handler: "main.app"
# (archivo main.py y objeto FastAPI llamado app)
CMD ["main.app"]
