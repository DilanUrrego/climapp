# Script para limpiar el despliegue de CLIMAPP en Minikube
# PowerShell Script

Write-Host "=====================================" -ForegroundColor Cyan
Write-Host "  CLIMAPP - Limpieza de Despliegue  " -ForegroundColor Cyan
Write-Host "=====================================" -ForegroundColor Cyan
Write-Host ""

Write-Host "ADVERTENCIA: Este script eliminará todos los recursos de CLIMAPP en Kubernetes." -ForegroundColor Yellow
Write-Host ""
$confirmacion = Read-Host "¿Estás seguro de que deseas continuar? (S/N)"

if ($confirmacion -ne "S" -and $confirmacion -ne "s") {
    Write-Host "Operación cancelada." -ForegroundColor Red
    exit 0
}

Write-Host ""
Write-Host "Eliminando recursos de Kubernetes..." -ForegroundColor Yellow
Write-Host ""

Write-Host "1. Eliminando Frontend..." -ForegroundColor Cyan
kubectl delete -f kube/frontend-deployment.yaml --ignore-not-found=true

Write-Host "2. Eliminando Backend..." -ForegroundColor Cyan
kubectl delete -f kube/backend-deployment.yaml --ignore-not-found=true

Write-Host "3. Eliminando Base de Datos..." -ForegroundColor Cyan
kubectl delete -f kube/database-deployment.yaml --ignore-not-found=true

Write-Host "4. Eliminando ConfigMap y Secrets..." -ForegroundColor Cyan
kubectl delete -f kube/configmap.yaml --ignore-not-found=true
kubectl delete -f kube/secret.yaml --ignore-not-found=true

Write-Host ""
Write-Host "Esperando a que los recursos se eliminen..." -ForegroundColor Yellow
Start-Sleep -Seconds 5

Write-Host ""
Write-Host "Estado actual del cluster:" -ForegroundColor Yellow
kubectl get all
Write-Host ""

Write-Host "=====================================" -ForegroundColor Cyan
Write-Host "  Limpieza Completada" -ForegroundColor Green
Write-Host "=====================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Nota: El PVC puede seguir existiendo. Para eliminarlo completamente:" -ForegroundColor Yellow
Write-Host "  kubectl delete pvc postgres-pvc" -ForegroundColor Cyan
Write-Host ""
Write-Host "Para detener Minikube:" -ForegroundColor Yellow
Write-Host "  minikube stop" -ForegroundColor Cyan
Write-Host ""
Write-Host "Para eliminar completamente el cluster de Minikube:" -ForegroundColor Yellow
Write-Host "  minikube delete" -ForegroundColor Cyan
Write-Host ""
