# Script para generar tráfico de prueba en CLIMAPP
# Esto ayudará a visualizar métricas en Grafana

Write-Host "Generando trafico de prueba para CLIMAPP Backend..." -ForegroundColor Green
Write-Host ""

$baseUrl = "http://localhost:8090"

# Verificar que el backend esté disponible
Write-Host "Verificando disponibilidad del backend..." -ForegroundColor Cyan
try {
    $response = Invoke-WebRequest -Uri "$baseUrl/" -Method GET -UseBasicParsing
    Write-Host "Backend disponible" -ForegroundColor Green
} catch {
    Write-Host "Error: Backend no disponible en $baseUrl" -ForegroundColor Red
    Write-Host "Por favor ejecuta: docker-compose up -d" -ForegroundColor Yellow
    exit 1
}

Write-Host ""
Write-Host "Generando solicitudes para crear metricas..." -ForegroundColor Cyan
Write-Host ""

# Ciudades para probar
$ciudades = @("bogota", "medellin", "cali", "barranquilla", "cartagena", "bucaramanga", "pereira", "manizales")

# Generar solicitudes GET al endpoint de clima
Write-Host "1. Consultando clima de diferentes ciudades..." -ForegroundColor Yellow
foreach ($ciudad in $ciudades) {
    for ($i = 1; $i -le 10; $i++) {
        try {
            $response = Invoke-WebRequest -Uri "$baseUrl/clima/$ciudad" -Method GET -UseBasicParsing
            Write-Host "   GET /clima/$ciudad - Status: $($response.StatusCode)" -ForegroundColor Gray
            Start-Sleep -Milliseconds 100
        } catch {
            Write-Host "   GET /clima/$ciudad - Error" -ForegroundColor Red
        }
    }
}

Write-Host ""
Write-Host "2. Consultando favoritos..." -ForegroundColor Yellow
for ($i = 1; $i -le 15; $i++) {
    try {
        $response = Invoke-WebRequest -Uri "$baseUrl/favoritos" -Method GET -UseBasicParsing
        Write-Host "   GET /favoritos - Status: $($response.StatusCode)" -ForegroundColor Gray
        Start-Sleep -Milliseconds 150
    } catch {
        Write-Host "   GET /favoritos - Error" -ForegroundColor Red
    }
}

Write-Host ""
Write-Host "3. Consultando endpoint raiz..." -ForegroundColor Yellow
for ($i = 1; $i -le 20; $i++) {
    try {
        $response = Invoke-WebRequest -Uri "$baseUrl/" -Method GET -UseBasicParsing
        Write-Host "   GET / - Status: $($response.StatusCode)" -ForegroundColor Gray
        Start-Sleep -Milliseconds 50
    } catch {
        Write-Host "   GET / - Error" -ForegroundColor Red
    }
}

Write-Host ""
Write-Host "4. Generando algunos errores 404..." -ForegroundColor Yellow
$endpointsInvalidos = @("clima/ciudadinexistente", "ruta/invalida", "endpoint/noexiste")
foreach ($endpoint in $endpointsInvalidos) {
    for ($i = 1; $i -le 5; $i++) {
        try {
            $response = Invoke-WebRequest -Uri "$baseUrl/$endpoint" -Method GET -UseBasicParsing -ErrorAction SilentlyContinue
        } catch {
            Write-Host "   GET /$endpoint - Status: 404 (esperado)" -ForegroundColor Gray
        }
        Start-Sleep -Milliseconds 100
    }
}

Write-Host ""
Write-Host "Generacion de trafico completada!" -ForegroundColor Green
Write-Host ""
Write-Host "Ahora puedes ver las metricas en:" -ForegroundColor Cyan
Write-Host "   - Grafana: http://localhost:3001 (admin/admin)" -ForegroundColor White
Write-Host "   - Prometheus: http://localhost:9090" -ForegroundColor White
Write-Host "   - Metricas raw: http://localhost:8090/metrics" -ForegroundColor White
Write-Host ""
Write-Host "Tip: Ejecuta este script varias veces para ver las metricas en tiempo real" -ForegroundColor Yellow

