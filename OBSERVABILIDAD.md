# 📊 Observabilidad - CLIMAPP Backend

## Herramientas Implementadas

Este proyecto utiliza **Prometheus + Grafana** para la observabilidad del backend FastAPI.

### 🔧 Componentes

- **Prometheus**: Recolección de métricas en tiempo real
- **Grafana**: Visualización de métricas con dashboards interactivos
- **prometheus-fastapi-instrumentator**: Biblioteca para instrumentar automáticamente FastAPI

## 🚀 Cómo usar

### 1. Iniciar los servicios

```bash
docker-compose up -d
```

Esto levantará:
- Backend (puerto 8090)
- Frontend (puerto 3000)
- Prometheus (puerto 9090)
- Grafana (puerto 3001)
- PostgreSQL (puerto 5432)

### 2. Acceder a las interfaces

#### Prometheus
- URL: http://localhost:9090
- Aquí puedes ver las métricas raw y hacer consultas PromQL

#### Grafana
- URL: http://localhost:3001
- Usuario: `admin`
- Contraseña: `admin`

### 3. Ver el Dashboard

Al acceder a Grafana:
1. Ve a "Dashboards" en el menú lateral
2. Busca "CLIMAPP Backend Metrics"
3. ¡Listo! Verás las métricas de tu backend

## 📈 Métricas Disponibles

El dashboard muestra:

1. **Requests per Second**: Solicitudes HTTP por segundo
2. **Total HTTP Requests**: Contador total de requests
3. **Average Request Duration**: Tiempo promedio de respuesta
4. **HTTP Status Codes Distribution**: Distribución de códigos de estado (200, 404, 500, etc.)
5. **Requests by Endpoint**: Tráfico por cada endpoint de la API

## 🔍 Endpoint de Métricas

Las métricas se exponen en:
```
http://localhost:8090/metrics
```

Puedes acceder directamente para ver las métricas en formato Prometheus.

## 📊 Ejemplo de métricas recolectadas

```
# HELP http_requests_total Total count of HTTP requests
# TYPE http_requests_total counter
http_requests_total{handler="/clima",method="GET",status="200"} 150

# HELP http_request_duration_seconds HTTP request latency
# TYPE http_request_duration_seconds histogram
http_request_duration_seconds_bucket{handler="/clima",method="GET",le="0.1"} 145
http_request_duration_seconds_bucket{handler="/clima",method="GET",le="0.5"} 150

# HELP http_requests_in_progress Number of HTTP requests in progress
# TYPE http_requests_in_progress gauge
http_requests_in_progress 2
```

## 🛠️ Generar tráfico para pruebas

Para ver métricas en acción, genera solicitudes al backend:

```bash
# Hacer varias requests al endpoint de clima
for i in {1..50}; do curl "http://localhost:8090/clima/bogota"; done

# Ver favoritos
curl http://localhost:8090/favoritos
```

## 📸 Capturas recomendadas para evidencia

1. Dashboard principal de Grafana mostrando todas las métricas
2. Panel de "Requests by Endpoint" mostrando tráfico
3. Distribución de códigos HTTP
4. Interfaz de Prometheus mostrando targets activos (http://localhost:9090/targets)

## 🔄 Actualizar configuración

Si necesitas modificar la configuración:

1. **Prometheus**: Edita `prometheus.yml`
2. **Grafana datasource**: Edita `grafana/provisioning/datasources/prometheus.yml`
3. **Dashboard**: Edita `grafana/provisioning/dashboards/climapp-dashboard.json`

Luego reinicia los servicios:
```bash
docker-compose restart prometheus grafana
```

## 📝 Archivos de configuración

```
climapp/
├── prometheus.yml                          # Configuración de Prometheus
├── docker-compose.yaml                     # Servicios de observabilidad añadidos
└── grafana/
    └── provisioning/
        ├── datasources/
        │   └── prometheus.yml              # Datasource automático
        └── dashboards/
            ├── dashboard.yml               # Proveedor de dashboards
            └── climapp-dashboard.json      # Dashboard preconfigurado
```

## ✅ Verificar que todo funciona

1. **Backend está instrumentado**:
   ```bash
   curl http://localhost:8090/metrics
   ```
   Deberías ver métricas en formato Prometheus

2. **Prometheus recolecta métricas**:
   - Ve a http://localhost:9090/targets
   - El target "climapp-backend" debe estar "UP"

3. **Grafana muestra el dashboard**:
   - Accede a http://localhost:3001
   - Login con admin/admin
   - Ve al dashboard "CLIMAPP Backend Metrics"

## 🎯 Beneficios de esta implementación

- ✅ **Gratuita y open source**
- ✅ **Fácil de configurar** con Docker Compose
- ✅ **Métricas automáticas** sin modificar endpoints existentes
- ✅ **Dashboards visuales** listos para usar
- ✅ **Configuración persistente** con provisioning
- ✅ **Producción-ready** - usado por miles de empresas

## 📚 Recursos adicionales

- [Documentación Prometheus](https://prometheus.io/docs/)
- [Documentación Grafana](https://grafana.com/docs/)
- [prometheus-fastapi-instrumentator](https://github.com/trallnag/prometheus-fastapi-instrumentator)
