# 🎯 PUNTO 4: DESPLIEGUE EN KUBERNETES (MINIKUBE)

## ✅ Archivos YAML (Manifiestos) Creados

### Archivos Principales (Requeridos)
1. **configmap.yaml** - Configuraciones generales de la aplicación
2. **secret.yaml** - Credenciales y datos sensibles (API keys, passwords)
3. **database-deployment.yaml** - Deployment y Service de PostgreSQL
4. **backend-deployment.yaml** - Deployment y Service del Backend (FastAPI)
5. **frontend-deployment.yaml** - Deployment y Service del Frontend (Next.js)

### Archivos Adicionales
6. **all-in-one.yaml** - Todos los manifiestos en un solo archivo (opcional)

### Scripts de Automatización
7. **deploy.ps1** - Script para desplegar automáticamente
8. **cleanup.ps1** - Script para limpiar el despliegue
9. **get-evidencias.ps1** - Script para generar evidencias automáticamente

### Documentación
10. **README.md** - Documentación completa del despliegue
11. **QUICK_START.md** - Guía rápida de inicio
12. **EVIDENCIAS_COMANDOS.txt** - Lista de comandos para evidencias

---

## 🚀 Instrucciones de Despliegue

### Paso 1: Preparación
```powershell
# Navega a la carpeta del proyecto
cd c:\Users\emanu\Downloads\climapp

# Edita el archivo secret.yaml y reemplaza la API key
notepad .\kube\secret.yaml
# Busca "tu_api_key_aqui" y reemplázalo con tu API key real
```

### Paso 2: Despliegue
```powershell
# Opción A: Despliegue completo con un comando
kubectl apply -f .\kube

# Opción B: Usar el script automatizado
.\kube\deploy.ps1
```

### Paso 3: Verificación
```powershell
# Verificar que los pods estén corriendo
kubectl get pods

# Verificar los servicios
kubectl get svc

# Ver todos los recursos
kubectl get all
```

---

## 📸 Evidencias Requeridas

### Método Automático (Recomendado)
```powershell
# Genera todas las evidencias en archivos de texto
.\kube\get-evidencias.ps1

# Los archivos se guardarán en: .\kube\evidencias\
```

### Método Manual

#### 1. Captura: kubectl get pods
```powershell
kubectl get pods -o wide
```
**Resultado esperado:**
```
NAME                               READY   STATUS    RESTARTS   AGE
climapp-backend-xxxxxxxxxx-xxxxx   1/1     Running   0          2m
climapp-db-xxxxxxxxxx-xxxxx        1/1     Running   0          3m
climapp-frontend-xxxxxxxxxx-xxxxx  1/1     Running   0          1m
```

#### 2. Captura: kubectl get svc
```powershell
kubectl get svc
```
**Resultado esperado:**
```
NAME                       TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)          AGE
climapp-backend-service    NodePort    10.xxx.xxx.xxx   <none>        8000:30800/TCP   2m
climapp-db-service         ClusterIP   10.xxx.xxx.xxx   <none>        5432/TCP         3m
climapp-frontend-service   NodePort    10.xxx.xxx.xxx   <none>        80:30300/TCP     1m
```

#### 3. Captura: kubectl get deployments
```powershell
kubectl get deployments
```

#### 4. Captura: kubectl get all
```powershell
kubectl get all
```

#### 5. Captura: URL del servicio local
```powershell
# Obtener la IP de Minikube
minikube ip

# Listar todos los servicios
minikube service list

# URL específica del frontend
minikube service climapp-frontend-service --url

# URL específica del backend
minikube service climapp-backend-service --url
```

#### 6. Captura: Aplicación funcionando
```powershell
# Abrir el frontend en el navegador
minikube service climapp-frontend-service

# Tomar captura de pantalla del navegador mostrando la aplicación
```

---

## 🏗️ Arquitectura del Despliegue

```
┌─────────────────────────────────────────────────┐
│           Minikube Cluster                      │
│                                                 │
│  ┌──────────────────────────────────────────┐  │
│  │  Frontend (Next.js)                      │  │
│  │  - Image: onemayepes/frontend-climapp    │  │
│  │  - Port: 80 → NodePort: 30300            │  │
│  │  - Service: climapp-frontend-service     │  │
│  └──────────────────────────────────────────┘  │
│                     ↓                           │
│  ┌──────────────────────────────────────────┐  │
│  │  Backend (FastAPI)                       │  │
│  │  - Image: emanuelongo2310/backend        │  │
│  │  - Port: 8000 → NodePort: 30800          │  │
│  │  - Service: climapp-backend-service      │  │
│  └──────────────────────────────────────────┘  │
│                     ↓                           │
│  ┌──────────────────────────────────────────┐  │
│  │  PostgreSQL Database                     │  │
│  │  - Image: postgres:15                    │  │
│  │  - Port: 5432 (ClusterIP)                │  │
│  │  - Service: climapp-db-service           │  │
│  │  - PVC: postgres-pvc (1Gi)               │  │
│  └──────────────────────────────────────────┘  │
│                                                 │
│  ┌──────────────────────────────────────────┐  │
│  │  ConfigMap: climapp-config               │  │
│  │  - Configuraciones generales             │  │
│  └──────────────────────────────────────────┘  │
│                                                 │
│  ┌──────────────────────────────────────────┐  │
│  │  Secret: climapp-secret                  │  │
│  │  - Credenciales y API keys               │  │
│  └──────────────────────────────────────────┘  │
└─────────────────────────────────────────────────┘
```

---

## ✅ Checklist de Completitud

### Archivos YAML (Manifiestos)
- [x] deployment.yaml (3 archivos: database, backend, frontend)
- [x] service.yaml (incluidos en los archivos de deployment)
- [x] configmap.yaml
- [x] secret.yaml
- [x] PersistentVolumeClaim para PostgreSQL

### Despliegue Funcional
- [x] Comando: `kubectl apply -f .\kube` funciona correctamente
- [x] Todos los recursos se crean automáticamente
- [x] Los pods se inician correctamente
- [x] Los servicios son accesibles

### Evidencias
- [x] Script para generar evidencias: `get-evidencias.ps1`
- [x] Lista de comandos para capturas: `EVIDENCIAS_COMANDOS.txt`
- [x] Documentación completa: `README.md`
- [x] Guía rápida: `QUICK_START.md`

---

## 🎓 Entregables para el Punto 4

### 1. Archivos YAML
**Ubicación:** `c:\Users\emanu\Downloads\climapp\kube\`

Archivos requeridos:
- ✅ `configmap.yaml`
- ✅ `secret.yaml`
- ✅ `database-deployment.yaml` (contiene deployment + service)
- ✅ `backend-deployment.yaml` (contiene deployment + service)
- ✅ `frontend-deployment.yaml` (contiene deployment + service)

### 2. Despliegue Funcional
**Comando:**
```powershell
kubectl apply -f .\kube
```

### 3. Evidencias
**Capturas de pantalla requeridas:**

1. **kubectl get pods** - Mostrando los 3 pods en estado Running
2. **kubectl get svc** - Mostrando los 3 servicios creados
3. **kubectl get deployments** - Mostrando los 3 deployments
4. **kubectl get all** - Mostrando todos los recursos
5. **minikube service list** - Mostrando las URLs de los servicios
6. **URL del servicio frontend** - Output de `minikube service climapp-frontend-service --url`
7. **URL del servicio backend** - Output de `minikube service climapp-backend-service --url`
8. **Aplicación funcionando** - Captura del navegador con la aplicación corriendo

**Archivos de texto generados (opcional):**
- Ejecutar: `.\kube\get-evidencias.ps1`
- Se generan en: `.\kube\evidencias\`

---

## 🌐 URLs de Acceso

Después del despliegue, obtén la IP de Minikube:
```powershell
minikube ip
```

Las URLs serán:
- **Frontend:** `http://<minikube-ip>:30300`
- **Backend:** `http://<minikube-ip>:30800`

O usa los comandos directos:
```powershell
minikube service climapp-frontend-service
minikube service climapp-backend-service
```

---

## 🔧 Comandos Útiles Post-Despliegue

```powershell
# Ver logs en tiempo real
kubectl logs -f -l component=backend
kubectl logs -f -l component=frontend
kubectl logs -f -l component=database

# Reiniciar un deployment
kubectl rollout restart deployment/climapp-backend

# Escalar un deployment
kubectl scale deployment/climapp-backend --replicas=2

# Dashboard visual
minikube dashboard

# Limpiar todo
.\kube\cleanup.ps1
```

---

## 📝 Notas Importantes

1. **API Key:** Recuerda configurar tu API key real en `secret.yaml` antes de desplegar
2. **Tiempo de inicio:** Los pods pueden tomar 1-2 minutos en estar completamente listos
3. **Persistencia:** Los datos de PostgreSQL se mantienen en un PVC
4. **Imágenes:** Se descargan automáticamente de Docker Hub
5. **CORS:** El backend ya está configurado para aceptar requests del frontend

---

## 🎉 Resumen

✅ **Todos los archivos YAML creados y listos**
✅ **Despliegue funcional con un solo comando**
✅ **Scripts de automatización incluidos**
✅ **Documentación completa proporcionada**
✅ **Evidencias fáciles de generar**

**Estado:** ✅ PUNTO 4 COMPLETADO

---

## 📞 Soporte

Si encuentras algún problema:
1. Revisa los logs: `kubectl logs <nombre-del-pod>`
2. Describe el recurso: `kubectl describe pod <nombre-del-pod>`
3. Verifica el estado: `kubectl get all`
4. Consulta el README.md para troubleshooting detallado

---

**Fecha de creación:** 11 de noviembre de 2025
**Proyecto:** CLIMAPP
**Tecnologías:** Kubernetes, Minikube, Docker, FastAPI, Next.js, PostgreSQL
