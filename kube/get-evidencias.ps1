# Script para obtener evidencias del despliegue en Kubernetes
# PowerShell Script

Write-Host "=====================================" -ForegroundColor Cyan
Write-Host "  CLIMAPP - Evidencias de Despliegue" -ForegroundColor Cyan
Write-Host "=====================================" -ForegroundColor Cyan
Write-Host ""

# Crear directorio para evidencias
$evidenciasDir = ".\kube\evidencias"
if (!(Test-Path $evidenciasDir)) {
    New-Item -ItemType Directory -Path $evidenciasDir | Out-Null
}

$timestamp = Get-Date -Format "yyyyMMdd_HHmmss"

Write-Host "1. Obteniendo información de Pods..." -ForegroundColor Yellow
kubectl get pods -o wide | Tee-Object -FilePath "$evidenciasDir\pods_$timestamp.txt"
Write-Host ""

Write-Host "2. Obteniendo información de Services..." -ForegroundColor Yellow
kubectl get svc | Tee-Object -FilePath "$evidenciasDir\services_$timestamp.txt"
Write-Host ""

Write-Host "3. Obteniendo información de Deployments..." -ForegroundColor Yellow
kubectl get deployments | Tee-Object -FilePath "$evidenciasDir\deployments_$timestamp.txt"
Write-Host ""

Write-Host "4. Obteniendo información de PVC..." -ForegroundColor Yellow
kubectl get pvc | Tee-Object -FilePath "$evidenciasDir\pvc_$timestamp.txt"
Write-Host ""

Write-Host "5. Obteniendo todos los recursos..." -ForegroundColor Yellow
kubectl get all | Tee-Object -FilePath "$evidenciasDir\all_resources_$timestamp.txt"
Write-Host ""

Write-Host "6. Obteniendo ConfigMaps..." -ForegroundColor Yellow
kubectl get configmap | Tee-Object -FilePath "$evidenciasDir\configmaps_$timestamp.txt"
Write-Host ""

Write-Host "7. Obteniendo Secrets..." -ForegroundColor Yellow
kubectl get secrets | Tee-Object -FilePath "$evidenciasDir\secrets_$timestamp.txt"
Write-Host ""

Write-Host "8. Describiendo Pods..." -ForegroundColor Yellow
kubectl describe pods | Out-File -FilePath "$evidenciasDir\pods_describe_$timestamp.txt"
Write-Host "   Guardado en: $evidenciasDir\pods_describe_$timestamp.txt"
Write-Host ""

Write-Host "9. Obteniendo logs del backend..." -ForegroundColor Yellow
$backendPod = kubectl get pods -l component=backend -o jsonpath="{.items[0].metadata.name}" 2>$null
if ($backendPod) {
    kubectl logs $backendPod --tail=100 | Out-File -FilePath "$evidenciasDir\backend_logs_$timestamp.txt"
    Write-Host "   Logs del backend guardados."
} else {
    Write-Host "   No se encontró el pod del backend." -ForegroundColor Red
}
Write-Host ""

Write-Host "10. Obteniendo logs del frontend..." -ForegroundColor Yellow
$frontendPod = kubectl get pods -l component=frontend -o jsonpath="{.items[0].metadata.name}" 2>$null
if ($frontendPod) {
    kubectl logs $frontendPod --tail=100 | Out-File -FilePath "$evidenciasDir\frontend_logs_$timestamp.txt"
    Write-Host "   Logs del frontend guardados."
} else {
    Write-Host "   No se encontró el pod del frontend." -ForegroundColor Red
}
Write-Host ""

Write-Host "11. Obteniendo logs de la base de datos..." -ForegroundColor Yellow
$dbPod = kubectl get pods -l component=database -o jsonpath="{.items[0].metadata.name}" 2>$null
if ($dbPod) {
    kubectl logs $dbPod --tail=100 | Out-File -FilePath "$evidenciasDir\database_logs_$timestamp.txt"
    Write-Host "   Logs de la base de datos guardados."
} else {
    Write-Host "   No se encontró el pod de la base de datos." -ForegroundColor Red
}
Write-Host ""

Write-Host "12. Obteniendo URLs de servicios..." -ForegroundColor Yellow
$minikubeIP = minikube ip
$frontendURL = "http://${minikubeIP}:30300"
$backendURL = "http://${minikubeIP}:30800"

$urls = @"
====================================
URLs de Acceso a la Aplicación
====================================

IP de Minikube: $minikubeIP

Frontend: $frontendURL
Backend:  $backendURL

Comandos para abrir en navegador:
- minikube service climapp-frontend-service
- minikube service climapp-backend-service

Fecha: $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")
====================================
"@

$urls | Out-File -FilePath "$evidenciasDir\urls_$timestamp.txt"
$urls
Write-Host ""

Write-Host "=====================================" -ForegroundColor Cyan
Write-Host "  Evidencias Generadas Exitosamente" -ForegroundColor Green
Write-Host "=====================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Ubicación: $evidenciasDir" -ForegroundColor Yellow
Write-Host ""
Write-Host "Archivos generados:" -ForegroundColor Yellow
Get-ChildItem $evidenciasDir | Where-Object { $_.Name -like "*$timestamp*" } | ForEach-Object {
    Write-Host "  - $($_.Name)" -ForegroundColor Cyan
}
Write-Host ""

Write-Host "Comandos adicionales útiles:" -ForegroundColor Yellow
Write-Host "  - Para tomar captura de pantalla del navegador después de abrir:" -ForegroundColor Cyan
Write-Host "    minikube service climapp-frontend-service" -ForegroundColor White
Write-Host ""
Write-Host "  - Para ver el dashboard de Kubernetes:" -ForegroundColor Cyan
Write-Host "    minikube dashboard" -ForegroundColor White
Write-Host ""
