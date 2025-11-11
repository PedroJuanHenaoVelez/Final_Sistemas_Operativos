#!/bin/bash

# ----------------------------
# CONFIGURACIÓN INICIAL
# ----------------------------

AWS_REGION="us-east-1"               # Cambia si usas otra región
REPO_NAME="lambda-final-repo"        # Nombre del repositorio en ECR
IMAGE_TAG="latest"

# Obtener ID de cuenta AWS
ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)

echo "🚀 Iniciando despliegue en AWS ECR..."
echo "Cuenta AWS: $ACCOUNT_ID"
echo "Región: $AWS_REGION"
echo "Repositorio: $REPO_NAME"

# ----------------------------
# 1️⃣ Crear el repositorio si no existe
# ----------------------------
aws ecr describe-repositories --repository-names $REPO_NAME --region $AWS_REGION >/dev/null 2>&1
if [ $? -ne 0 ]; then
  echo "📦 Repositorio no encontrado. Creando nuevo..."
  aws ecr create-repository --repository-name $REPO_NAME --region $AWS_REGION
else
  echo "📦 Repositorio ya existe, continuando..."
fi

# ----------------------------
# 2️⃣ Login en ECR
# ----------------------------
echo "🔐 Iniciando sesión en ECR..."
aws ecr get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin $ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com

# ----------------------------
# 3️⃣ Construir la imagen Docker
# ----------------------------
echo "⚙️ Construyendo imagen Docker..."
docker build -t $REPO_NAME .

# ----------------------------
# 4️⃣ Etiquetar la imagen
# ----------------------------
echo "🏷️ Etiquetando imagen como 'latest'..."
docker tag $REPO_NAME:latest $ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$REPO_NAME:$IMAGE_TAG

# ----------------------------
# 5️⃣ Subir la imagen a ECR
# ----------------------------
echo "⬆️ Subiendo imagen a ECR..."
docker push $ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$REPO_NAME:$IMAGE_TAG

# ----------------------------
# FINAL
# ----------------------------
echo "✅ Imagen subida correctamente a:"
echo "$ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$REPO_NAME:$IMAGE_TAG"
