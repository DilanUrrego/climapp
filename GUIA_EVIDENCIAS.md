# 📸 Guía de Evidencias para Observabilidad

## Evidencias requeridas para el proyecto

Para cumplir con el requisito de observabilidad, debes tomar las siguientes capturas de pantalla:

---

## 1️⃣ Dashboard Principal de Grafana ⭐ (OBLIGATORIO)

**URL**: http://localhost:3001

**Qué mostrar**:
- Dashboard completo "CLIMAPP Backend Metrics"
- Todos los paneles visibles con datos
- Panel superior mostrando el período de tiempo (últimos 15 minutos)
- Datos actualizándose en tiempo real

**Cómo tomarlo**:
1. Ejecuta `.\generar-trafico.ps1` para tener datos
2. Espera 30 segundos
3. Accede a Grafana (http://localhost:3001)
4. Ve al dashboard "CLIMAPP Backend Metrics"
5. Toma captura de pantalla completa

**Tip**: Puedes usar el botón de "Full screen" (F) en cada panel para resaltar métricas específicas

---

## 2️⃣ Prometheus Targets ⭐ (OBLIGATORIO)

**URL**: http://localhost:9090/targets

**Qué mostrar**:
- Lista de targets
- "climapp-backend" en estado **UP** (verde)
- Última vez que se recolectaron métricas
- Endpoint del backend visible (backend:8000/metrics)

**Cómo tomarlo**:
1. Accede a http://localhost:9090/targets
2. Verifica que "climapp-backend" esté UP
3. Toma captura de pantalla completa

---

## 3️⃣ Métricas Raw del Backend ⭐ (OBLIGATORIO)

**URL**: http://localhost:8090/metrics

**Qué mostrar**:
- Endpoint /metrics respondiendo
- Métricas en formato Prometheus
- Valores diferentes de 0 (después de generar tráfico)

**Qué buscar en la página**:
```
http_requests_total{...} XX
http_request_duration_seconds_sum{...} X.XXX
http_requests_in_progress XX
```

**Cómo tomarlo**:
1. Ejecuta `.\generar-trafico.ps1`
2. Accede a http://localhost:8090/metrics
3. Toma captura mostrando las métricas

---

## 4️⃣ Paneles Individuales con Datos (RECOMENDADO)

Toma capturas de paneles específicos en Grafana mostrando:

### A) Requests per Second
- Muestra el tráfico en tiempo real
- Diferentes endpoints con colores

### B) HTTP Status Codes Distribution (Gráfico de pastel)
- Distribución de códigos 200, 404, etc.
- Porcentajes visibles

### C) Requests by Endpoint
- Barras mostrando qué endpoints son más usados
- Comparación entre /clima, /favoritos, etc.

### D) Average Request Duration
- Tiempo de respuesta promedio
- Líneas de tendencia

---

## 5️⃣ Docker Compose Services (RECOMENDADO)

**Comando**: 
```powershell
docker-compose ps
```

**Qué mostrar**:
- 5 contenedores corriendo (db, backend, frontend, prometheus, grafana)
- Todos en estado "Up"
- Puertos correctamente mapeados

**Cómo tomarlo**:
1. Abre PowerShell en la carpeta del proyecto
2. Ejecuta `docker-compose ps`
3. Toma captura de la terminal

---

## 6️⃣ Configuración de Prometheus (OPCIONAL pero impresionante)

**URL**: http://localhost:9090/config

**Qué mostrar**:
- Configuración YAML de Prometheus
- Job "climapp-backend" configurado
- Scrape interval visible

---

## 7️⃣ Query en Prometheus (OPCIONAL pero impresionante)

**URL**: http://localhost:9090/graph

**Qué mostrar**:
1. Ejecuta una query como: `rate(http_requests_total[5m])`
2. Muestra el gráfico generado
3. Tabla con los valores

---

## 📋 Checklist de Evidencias

Para el proyecto, asegúrate de tener:

### Evidencias Mínimas (Obligatorias):
- [ ] Dashboard de Grafana con todas las métricas
- [ ] Prometheus Targets mostrando backend UP
- [ ] Endpoint /metrics del backend con datos

### Evidencias Adicionales (Recomendadas):
- [ ] Gráfico de "Requests per Second" en detalle
- [ ] Distribución de códigos HTTP (pie chart)
- [ ] Docker compose ps mostrando servicios
- [ ] Logs del backend mostrando instrumentación

### Evidencias Extra (Impresionantes):
- [ ] Query personalizada en Prometheus
- [ ] Comparación antes/después de generar tráfico
- [ ] Dashboard exportado (archivo JSON)
- [ ] Video corto mostrando métricas en tiempo real

---

## 🎬 Script de Demostración Recomendado

1. **Mostrar servicios corriendo**
   ```powershell
   docker-compose ps
   ```

2. **Mostrar backend sin tráfico**
   - Abrir Grafana → Dashboard → Todo en 0

3. **Generar tráfico**
   ```powershell
   .\generar-trafico.ps1
   ```

4. **Mostrar métricas actualizándose**
   - Volver a Grafana → Ver gráficos con datos
   - Mostrar Prometheus Targets
   - Mostrar endpoint /metrics

5. **Hacer queries en Prometheus**
   - Ejecutar: `rate(http_requests_total[5m])`
   - Mostrar resultados

---

## 💾 Exportar Dashboard (Para entregar archivo)

En Grafana:
1. Abre el dashboard "CLIMAPP Backend Metrics"
2. Haz clic en el ícono de compartir (arriba a la derecha)
3. Ve a "Export"
4. Selecciona "Export for sharing externally"
5. Clic en "Save to file"
6. Guarda como: `climapp-dashboard-evidencia.json`

Este archivo JSON se puede incluir en tu entrega como evidencia técnica.

---

## 📄 Documento de Evidencia Recomendado

Crea un documento (Word/PDF) con:

1. **Portada**: "Observabilidad - CLIMAPP Backend"
2. **Introducción**: Breve descripción de las herramientas (Prometheus + Grafana)
3. **Arquitectura**: Diagrama simple mostrando: Backend → Prometheus → Grafana
4. **Implementación**: Código relevante (main.py instrumentado)
5. **Configuración**: Fragmentos de prometheus.yml y docker-compose.yaml
6. **Capturas de pantalla**: Las 7 evidencias anteriores
7. **Métricas recolectadas**: Lista de métricas disponibles
8. **Conclusión**: Beneficios de la observabilidad implementada

---

## ✨ Tips para buenas evidencias

- ✅ Asegúrate de que haya datos en los gráficos (ejecuta generar-trafico.ps1)
- ✅ Usa capturas en alta resolución
- ✅ Incluye la barra de direcciones del navegador (muestra la URL)
- ✅ Muestra fechas/horas en las capturas
- ✅ Si haces un video, mantenlo bajo 2 minutos
- ✅ Explica qué muestra cada métrica

---

## 🚀 Comando Todo-en-Uno para Demostración

```powershell
# 1. Levantar servicios
docker-compose up -d

# 2. Esperar 30 segundos
Start-Sleep -Seconds 30

# 3. Verificar servicios
docker-compose ps

# 4. Generar tráfico
.\generar-trafico.ps1

# 5. Abrir navegadores automáticamente
Start-Process "http://localhost:3001"     # Grafana
Start-Process "http://localhost:9090"      # Prometheus
Start-Process "http://localhost:8090/metrics"  # Métricas
```

¡Listo para tomar todas las evidencias! 📸
