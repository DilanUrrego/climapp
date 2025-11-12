# CLIMAPP - Guía Rápida de Despliegue en Kubernetes

## ⚡ Inicio Rápido

### 1. Pre-requisitos
```powershell
# Verificar instalaciones
minikube version
kubectl version --client
```

### 2. Configurar Secret (IMPORTANTE)
Edita `kube/secret.yaml` y reemplaza `tu_api_key_aqui` con tu API key real de OpenWeatherMap.

### 3. Desplegar
```powershell
# Opción A: Usar el script automatizado
.\kube\deploy.ps1

# Opción B: Comando manual
kubectl apply -f .\kube
```

### 4. Verificar
```powershell
kubectl get pods
kubectl get svc
```

### 5. Acceder a la Aplicación
```powershell
# Abrir Frontend
minikube service climapp-frontend-service

# Abrir Backend
minikube service climapp-backend-service
```

### 6. Obtener Evidencias
```powershell
.\kube\get-evidencias.ps1
```

---

## 📋 Comandos Esenciales

### Ver estado
```powershell
kubectl get all
kubectl get pods -o wide
kubectl get svc
```

### Ver logs
```powershell
# Backend
kubectl logs -l component=backend --tail=50 -f

# Frontend
kubectl logs -l component=frontend --tail=50 -f

# Database
kubectl logs -l component=database --tail=50 -f
```

### Obtener URLs
```powershell
minikube ip
minikube service list
```

### Limpiar despliegue
```powershell
.\kube\cleanup.ps1
```

---

## 🎯 Evidencias para el Punto 4

### Comandos para capturas de pantalla:

1. **Estado de Pods**
```powershell
kubectl get pods -o wide
```

2. **Estado de Services**
```powershell
kubectl get svc
```

3. **Estado de Deployments**
```powershell
kubectl get deployments
```

4. **Todos los recursos**
```powershell
kubectl get all
```

5. **URL del servicio**
```powershell
minikube service climapp-frontend-service --url
minikube service climapp-backend-service --url
```

6. **Abrir en navegador**
```powershell
minikube service climapp-frontend-service
```

7. **Dashboard de Kubernetes** (opcional)
```powershell
minikube dashboard
```

---

## 🔧 Troubleshooting

### Pods en CrashLoopBackOff
```powershell
kubectl describe pod <nombre-del-pod>
kubectl logs <nombre-del-pod>
```

### Reiniciar un deployment
```powershell
kubectl rollout restart deployment/climapp-backend
kubectl rollout restart deployment/climapp-frontend
```

### Verificar conectividad
```powershell
kubectl exec -it <backend-pod> -- curl http://climapp-db-service:5432
```

### Actualizar imagen
```powershell
kubectl set image deployment/climapp-backend backend=emanuelongo2310/backend:latest
kubectl rollout status deployment/climapp-backend
```

---

## 📁 Estructura de Archivos

```
kube/
├── configmap.yaml              # Configuraciones generales
├── secret.yaml                 # Credenciales y API keys
├── database-deployment.yaml    # PostgreSQL deployment y service
├── backend-deployment.yaml     # Backend FastAPI deployment y service
├── frontend-deployment.yaml    # Frontend Next.js deployment y service
├── all-in-one.yaml            # Todos los manifiestos en un archivo
├── deploy.ps1                 # Script de despliegue automatizado
├── cleanup.ps1                # Script de limpieza
├── get-evidencias.ps1         # Script para generar evidencias
├── README.md                  # Documentación completa
└── QUICK_START.md             # Esta guía rápida
```

---

## 🌐 Puertos

- **Frontend**: NodePort 30300
- **Backend**: NodePort 30800
- **Database**: ClusterIP (solo interno)

---

## ✅ Checklist de Despliegue

- [ ] Minikube iniciado (`minikube start`)
- [ ] API key configurada en `secret.yaml`
- [ ] Manifiestos aplicados (`kubectl apply -f .\kube`)
- [ ] Pods en estado Running (`kubectl get pods`)
- [ ] Services creados (`kubectl get svc`)
- [ ] Aplicación accesible (abrir en navegador)
- [ ] Evidencias generadas (`.\kube\get-evidencias.ps1`)
- [ ] Capturas de pantalla tomadas

---

## 🎓 Para el Punto 4 de la Tarea

**Archivos YAML requeridos:** ✅
- ✅ deployment.yaml (database-deployment.yaml, backend-deployment.yaml, frontend-deployment.yaml)
- ✅ service.yaml (incluidos en los archivos de deployment)
- ✅ configmap.yaml
- ✅ secret.yaml

**Despliegue funcional:** ✅
```powershell
kubectl apply -f .\kube
```

**Evidencias requeridas:** ✅
1. Ejecutar: `.\kube\get-evidencias.ps1`
2. Tomar captura de: `kubectl get pods, svc, etc.`
3. Tomar captura de: URLs de servicio local
4. Tomar captura de: Aplicación funcionando en navegador

---

## 💡 Notas Importantes

1. **API Key**: No olvides configurar tu API key real en `secret.yaml`
2. **Persistencia**: Los datos de PostgreSQL se mantienen en un PVC
3. **Puertos**: El frontend estará en el puerto 30300 y el backend en el 30800
4. **Imágenes**: Las imágenes se descargan de Docker Hub automáticamente
5. **CORS**: El backend ya tiene configurado CORS para permitir el acceso del frontend

---

## 📞 Comandos de Ayuda

```powershell
# Ver ayuda de kubectl
kubectl --help

# Ver ayuda de minikube
minikube --help

# Ver recursos disponibles
kubectl api-resources

# Ver estado de Minikube
minikube status

# Ver IP de Minikube
minikube ip

# Listar servicios
minikube service list
```

---

¡Buena suerte con tu despliegue! 🚀
