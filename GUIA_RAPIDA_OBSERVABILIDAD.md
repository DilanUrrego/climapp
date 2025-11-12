# 🚀 Guía Rápida - Observabilidad CLIMAPP

## Pasos para implementar y probar la observabilidad

### 1️⃣ Reconstruir el contenedor del backend

El backend necesita instalar la nueva dependencia `prometheus-fastapi-instrumentator`:

```bash
docker-compose down
docker-compose build backend
docker-compose up -d
```

### 2️⃣ Verificar que los servicios estén corriendo

```bash
docker-compose ps
```

Deberías ver 5 contenedores activos:
- climapp_db
- climapp_backend
- climapp_frontend
- climapp_prometheus
- climapp_grafana

### 3️⃣ Verificar que las métricas se están exponiendo

Abre en tu navegador:
```
http://localhost:8090/metrics
```

Deberías ver métricas en formato Prometheus como:
```
http_requests_total{...} 0
http_request_duration_seconds{...} 0
```

### 4️⃣ Verificar que Prometheus está recolectando métricas

Abre en tu navegador:
```
http://localhost:9090/targets
```

El target "climapp-backend" debe aparecer en estado **UP** (verde).

### 5️⃣ Acceder a Grafana

Abre en tu navegador:
```
http://localhost:3001
```

- Usuario: `admin`
- Contraseña: `admin`

### 6️⃣ Ver el Dashboard

1. En Grafana, haz clic en el menú hamburguesa (☰) en la esquina superior izquierda
2. Ve a **"Dashboards"**
3. Busca **"CLIMAPP Backend Metrics"**
4. Haz clic en el dashboard

### 7️⃣ Generar tráfico para ver métricas

Ejecuta el script de generación de tráfico:

```powershell
.\generar-trafico.ps1
```

O manualmente:
```bash
# Hacer varias requests
curl http://localhost:8090/
curl http://localhost:8090/clima/bogota
curl http://localhost:8090/favoritos
```

### 8️⃣ Ver las métricas en tiempo real

Vuelve a Grafana y observa cómo se actualizan los gráficos:
- Requests per second
- Total requests
- Request duration
- Status codes distribution
- Requests by endpoint

## 📸 Capturas para evidencia

Toma capturas de:

1. **Dashboard completo de Grafana** mostrando todas las métricas
2. **Prometheus Targets** (http://localhost:9090/targets) mostrando el backend en UP
3. **Endpoint /metrics** (http://localhost:8090/metrics) mostrando las métricas raw
4. **Gráficos individuales** con datos reales después de generar tráfico

## ⚠️ Solución de problemas

### El backend no inicia
```bash
# Ver logs del backend
docker-compose logs backend

# Si hay error de dependencias, reconstruir
docker-compose build --no-cache backend
docker-compose up -d
```

### Grafana no muestra datos
```bash
# Verificar que Prometheus esté recogiendo métricas
# Ir a http://localhost:9090/targets
# El target debe estar UP

# Reiniciar servicios
docker-compose restart prometheus grafana
```

### No veo el dashboard en Grafana
```bash
# Verificar que los archivos de provisioning estén montados
docker-compose exec grafana ls -la /etc/grafana/provisioning/dashboards

# Reiniciar Grafana
docker-compose restart grafana
```

## 🎯 Comandos útiles

```bash
# Ver logs en tiempo real
docker-compose logs -f backend prometheus grafana

# Reiniciar solo los servicios de observabilidad
docker-compose restart prometheus grafana

# Ver logs específicos de un servicio
docker-compose logs backend
docker-compose logs prometheus
docker-compose logs grafana

# Detener todos los servicios
docker-compose down

# Detener y eliminar volúmenes (cuidado: borra datos)
docker-compose down -v
```

## ✅ Checklist de verificación

- [ ] Backend levanta sin errores
- [ ] Endpoint /metrics responde (http://localhost:8090/metrics)
- [ ] Prometheus muestra el target en UP (http://localhost:9090/targets)
- [ ] Grafana carga correctamente (http://localhost:3001)
- [ ] Dashboard "CLIMAPP Backend Metrics" está visible
- [ ] Al generar tráfico, las métricas se actualizan en Grafana
- [ ] Todos los paneles del dashboard muestran datos

## 📚 Documentación completa

Para más información, consulta `OBSERVABILIDAD.md`
