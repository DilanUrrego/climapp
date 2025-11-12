# Script de despliegue de CLIMAPP en Minikube
# PowerShell Script

Write-Host "=====================================" -ForegroundColor Cyan
Write-Host "  CLIMAPP - Despliegue en Minikube  " -ForegroundColor Cyan
Write-Host "=====================================" -ForegroundColor Cyan
Write-Host ""

# Verificar que minikube esté corriendo
Write-Host "1. Verificando estado de Minikube..." -ForegroundColor Yellow
$minikubeStatus = minikube status 2>&1
if ($LASTEXITCODE -ne 0) {
    Write-Host "   Minikube no está corriendo. Iniciando..." -ForegroundColor Red
    minikube start --driver=docker
    if ($LASTEXITCODE -ne 0) {
        Write-Host "   Error al iniciar Minikube. Abortando." -ForegroundColor Red
        exit 1
    }
} else {
    Write-Host "   Minikube está corriendo correctamente." -ForegroundColor Green
}
Write-Host ""

# Verificar kubectl
Write-Host "2. Verificando kubectl..." -ForegroundColor Yellow
kubectl version --client --short 2>&1 | Out-Null
if ($LASTEXITCODE -ne 0) {
    Write-Host "   kubectl no está instalado o no está en el PATH." -ForegroundColor Red
    exit 1
}
Write-Host "   kubectl está disponible." -ForegroundColor Green
Write-Host ""

# Aplicar manifiestos
Write-Host "3. Aplicando manifiestos de Kubernetes..." -ForegroundColor Yellow
Write-Host "   - Aplicando ConfigMap y Secrets..." -ForegroundColor Cyan
kubectl apply -f kube/configmap.yaml
kubectl apply -f kube/secret.yaml

Write-Host "   - Desplegando base de datos..." -ForegroundColor Cyan
kubectl apply -f kube/database-deployment.yaml

Write-Host "   - Esperando a que la base de datos esté lista..." -ForegroundColor Cyan
kubectl wait --for=condition=ready pod -l component=database --timeout=120s

Write-Host "   - Desplegando backend..." -ForegroundColor Cyan
kubectl apply -f kube/backend-deployment.yaml

Write-Host "   - Desplegando frontend..." -ForegroundColor Cyan
kubectl apply -f kube/frontend-deployment.yaml

Write-Host ""
Write-Host "4. Esperando a que todos los pods estén listos..." -ForegroundColor Yellow
Start-Sleep -Seconds 10

Write-Host ""
Write-Host "=====================================" -ForegroundColor Cyan
Write-Host "  Estado del Despliegue" -ForegroundColor Cyan
Write-Host "=====================================" -ForegroundColor Cyan
Write-Host ""

Write-Host "Pods:" -ForegroundColor Yellow
kubectl get pods
Write-Host ""

Write-Host "Services:" -ForegroundColor Yellow
kubectl get svc
Write-Host ""

Write-Host "Deployments:" -ForegroundColor Yellow
kubectl get deployments
Write-Host ""

Write-Host "PersistentVolumeClaims:" -ForegroundColor Yellow
kubectl get pvc
Write-Host ""

Write-Host "=====================================" -ForegroundColor Cyan
Write-Host "  URLs de Acceso" -ForegroundColor Cyan
Write-Host "=====================================" -ForegroundColor Cyan
Write-Host ""

$minikubeIP = minikube ip
Write-Host "IP de Minikube: $minikubeIP" -ForegroundColor Green
Write-Host ""
Write-Host "Frontend: http://${minikubeIP}:30300" -ForegroundColor Green
Write-Host "Backend:  http://${minikubeIP}:30800" -ForegroundColor Green
Write-Host ""

Write-Host "Para abrir el frontend en el navegador, ejecuta:" -ForegroundColor Yellow
Write-Host "  minikube service climapp-frontend-service" -ForegroundColor Cyan
Write-Host ""
Write-Host "Para abrir el backend en el navegador, ejecuta:" -ForegroundColor Yellow
Write-Host "  minikube service climapp-backend-service" -ForegroundColor Cyan
Write-Host ""

Write-Host "=====================================" -ForegroundColor Cyan
Write-Host "  Despliegue Completado!" -ForegroundColor Green
Write-Host "=====================================" -ForegroundColor Cyan
