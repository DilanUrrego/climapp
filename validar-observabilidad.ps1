# Script de validación para la implementación de observabilidad
# Ejecuta este script DESPUÉS de levantar los servicios con docker-compose up -d

Write-Host "🔍 Validando implementación de observabilidad..." -ForegroundColor Cyan
Write-Host ""

$errors = 0
$warnings = 0

# Función para verificar archivos
function Test-FileExists {
    param($path, $description)
    if (Test-Path $path) {
        Write-Host "✅ $description" -ForegroundColor Green
        return $true
    } else {
        Write-Host "❌ $description - NO ENCONTRADO" -ForegroundColor Red
        $script:errors++
        return $false
    }
}

# Función para verificar servicios HTTP
function Test-HttpEndpoint {
    param($url, $description)
    try {
        $response = Invoke-WebRequest -Uri $url -Method GET -UseBasicParsing -TimeoutSec 5
        Write-Host "✅ $description - Status: $($response.StatusCode)" -ForegroundColor Green
        return $true
    } catch {
        Write-Host "❌ $description - NO DISPONIBLE" -ForegroundColor Red
        Write-Host "   Error: $($_.Exception.Message)" -ForegroundColor Gray
        $script:errors++
        return $false
    }
}

# Función para verificar contenedores Docker
function Test-DockerContainer {
    param($containerName, $description)
    $container = docker ps --filter "name=$containerName" --format "{{.Status}}"
    if ($container -match "Up") {
        Write-Host "✅ $description - Corriendo" -ForegroundColor Green
        return $true
    } else {
        Write-Host "❌ $description - NO CORRIENDO" -ForegroundColor Red
        $script:errors++
        return $false
    }
}

Write-Host "📁 Verificando archivos de configuración..." -ForegroundColor Yellow
Write-Host ""

Test-FileExists ".\prometheus.yml" "prometheus.yml"
Test-FileExists ".\grafana\provisioning\datasources\prometheus.yml" "Datasource de Grafana"
Test-FileExists ".\grafana\provisioning\dashboards\dashboard.yml" "Configuración de dashboards"
Test-FileExists ".\grafana\provisioning\dashboards\climapp-dashboard.json" "Dashboard preconfigurado"
Test-FileExists ".\backend\requirements.txt" "requirements.txt del backend"
Test-FileExists ".\generar-trafico.ps1" "Script de generación de tráfico"

Write-Host ""
Write-Host "🐳 Verificando contenedores Docker..." -ForegroundColor Yellow
Write-Host ""

Test-DockerContainer "climapp_backend" "Backend"
Test-DockerContainer "climapp_prometheus" "Prometheus"
Test-DockerContainer "climapp_grafana" "Grafana"
Test-DockerContainer "climapp_db" "PostgreSQL"
Test-DockerContainer "climapp_frontend" "Frontend"

Write-Host ""
Write-Host "🌐 Verificando endpoints HTTP..." -ForegroundColor Yellow
Write-Host ""

$backendOk = Test-HttpEndpoint "http://localhost:8090/" "Backend raíz"
if ($backendOk) {
    Test-HttpEndpoint "http://localhost:8090/metrics" "Endpoint de métricas"
}

Test-HttpEndpoint "http://localhost:9090/-/healthy" "Prometheus health"
Test-HttpEndpoint "http://localhost:3001/api/health" "Grafana health"

Write-Host ""
Write-Host "🎯 Verificando targets de Prometheus..." -ForegroundColor Yellow
Write-Host ""

try {
    $prometheusTargets = Invoke-RestMethod -Uri "http://localhost:9090/api/v1/targets" -Method GET
    $backendTarget = $prometheusTargets.data.activeTargets | Where-Object { $_.job -eq "climapp-backend" }
    
    if ($backendTarget) {
        if ($backendTarget.health -eq "up") {
            Write-Host "✅ Target 'climapp-backend' está UP en Prometheus" -ForegroundColor Green
        } else {
            Write-Host "⚠️  Target 'climapp-backend' está DOWN en Prometheus" -ForegroundColor Yellow
            Write-Host "   Último error: $($backendTarget.lastError)" -ForegroundColor Gray
            $script:warnings++
        }
    } else {
        Write-Host "❌ Target 'climapp-backend' no encontrado en Prometheus" -ForegroundColor Red
        $script:errors++
    }
} catch {
    Write-Host "❌ No se pudo consultar targets de Prometheus" -ForegroundColor Red
    $script:errors++
}

Write-Host ""
Write-Host "📊 Verificando métricas del backend..." -ForegroundColor Yellow
Write-Host ""

try {
    $metrics = Invoke-WebRequest -Uri "http://localhost:8090/metrics" -Method GET -UseBasicParsing
    $metricsContent = $metrics.Content
    
    $expectedMetrics = @(
        "http_requests_total",
        "http_request_duration_seconds",
        "http_requests_in_progress"
    )
    
    foreach ($metric in $expectedMetrics) {
        if ($metricsContent -match $metric) {
            Write-Host "✅ Métrica '$metric' presente" -ForegroundColor Green
        } else {
            Write-Host "⚠️  Métrica '$metric' no encontrada" -ForegroundColor Yellow
            $script:warnings++
        }
    }
} catch {
    Write-Host "❌ No se pudieron verificar las métricas" -ForegroundColor Red
    $script:errors++
}

Write-Host ""
Write-Host "🔍 Verificando instrumentación en main.py..." -ForegroundColor Yellow
Write-Host ""

$mainPyContent = Get-Content ".\backend\app\main.py" -Raw
if ($mainPyContent -match "prometheus_fastapi_instrumentator") {
    Write-Host "✅ Import de Instrumentator presente" -ForegroundColor Green
} else {
    Write-Host "❌ Import de Instrumentator NO encontrado" -ForegroundColor Red
    $script:errors++
}

if ($mainPyContent -match "Instrumentator\(\)\.instrument\(app\)\.expose\(app\)") {
    Write-Host "✅ Instrumentación configurada correctamente" -ForegroundColor Green
} else {
    Write-Host "❌ Instrumentación NO configurada" -ForegroundColor Red
    $script:errors++
}

Write-Host ""
Write-Host "🔍 Verificando requirements.txt..." -ForegroundColor Yellow
Write-Host ""

$requirementsContent = Get-Content ".\backend\requirements.txt" -Raw
if ($requirementsContent -match "prometheus-fastapi-instrumentator") {
    Write-Host "✅ prometheus-fastapi-instrumentator en requirements.txt" -ForegroundColor Green
} else {
    Write-Host "❌ prometheus-fastapi-instrumentator NO en requirements.txt" -ForegroundColor Red
    $script:errors++
}

# Resumen final
Write-Host ""
Write-Host "================================================" -ForegroundColor Cyan
Write-Host "               RESUMEN DE VALIDACIÓN             " -ForegroundColor Cyan
Write-Host "================================================" -ForegroundColor Cyan
Write-Host ""

if ($errors -eq 0 -and $warnings -eq 0) {
    Write-Host "🎉 ¡TODO PERFECTO! La implementación está completa y funcionando." -ForegroundColor Green
    Write-Host ""
    Write-Host "Próximos pasos:" -ForegroundColor Cyan
    Write-Host "1. Ejecuta: .\generar-trafico.ps1" -ForegroundColor White
    Write-Host "2. Abre Grafana: http://localhost:3001 (admin/admin)" -ForegroundColor White
    Write-Host "3. Ve al dashboard: 'CLIMAPP Backend Metrics'" -ForegroundColor White
    Write-Host "4. Toma capturas de pantalla para tu evidencia" -ForegroundColor White
} elseif ($errors -eq 0) {
    Write-Host "⚠️  VALIDACIÓN COMPLETADA CON ADVERTENCIAS" -ForegroundColor Yellow
    Write-Host "Advertencias: $warnings" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "El sistema debería funcionar, pero revisa las advertencias arriba." -ForegroundColor Yellow
} else {
    Write-Host "❌ VALIDACIÓN FALLIDA" -ForegroundColor Red
    Write-Host "Errores: $errors" -ForegroundColor Red
    Write-Host "Advertencias: $warnings" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Pasos para solucionar:" -ForegroundColor Yellow
    Write-Host "1. Revisa los errores marcados arriba" -ForegroundColor White
    Write-Host "2. Ejecuta: docker-compose down" -ForegroundColor White
    Write-Host "3. Ejecuta: docker-compose build --no-cache backend" -ForegroundColor White
    Write-Host "4. Ejecuta: docker-compose up -d" -ForegroundColor White
    Write-Host "5. Espera 30 segundos y vuelve a ejecutar este script" -ForegroundColor White
}

Write-Host ""
Write-Host "Para más ayuda, consulta: GUIA_RAPIDA_OBSERVABILIDAD.md" -ForegroundColor Gray
