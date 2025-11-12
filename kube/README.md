# Despliegue de CLIMAPP en Kubernetes (Minikube)

Este directorio contiene los manifiestos de Kubernetes necesarios para desplegar la aplicación CLIMAPP en Minikube.

## Arquitectura del Despliegue

La aplicación está compuesta por tres componentes principales:
- **PostgreSQL Database**: Base de datos persistente
- **Backend (FastAPI)**: API REST en el puerto 30800
- **Frontend (Next.js)**: Aplicación web en el puerto 30300

## Archivos de Configuración

- `configmap.yaml`: Configuraciones no sensibles (hosts, puertos, etc.)
- `secret.yaml`: Datos sensibles (credenciales, API keys)
- `database-deployment.yaml`: Despliegue de PostgreSQL con PVC
- `backend-deployment.yaml`: Despliegue del backend FastAPI
- `frontend-deployment.yaml`: Despliegue del frontend Next.js

## Pre-requisitos

1. **Minikube instalado y en ejecución**
   ```bash
   minikube version
   minikube status
   ```

2. **kubectl instalado y configurado**
   ```bash
   kubectl version --client
   ```

3. **Iniciar Minikube** (si no está corriendo)
   ```bash
   minikube start --driver=docker
   ```

## Configuración Inicial

### 1. Editar el Secret con tus credenciales

Antes de desplegar, edita el archivo `secret.yaml` y actualiza:
- `WEATHER_API_KEY`: Tu API key de OpenWeatherMap o el servicio que uses
- `API_KEY`: Tu API key de OpenWeatherMap o el servicio que uses
- Opcionalmente, puedes cambiar las credenciales de PostgreSQL

```yaml
stringData:
  WEATHER_API_KEY: "TU_API_KEY_REAL_AQUI"
  API_KEY: "TU_API_KEY_REAL_AQUI"
```

## Despliegue

### Opción 1: Desplegar todos los recursos a la vez

```bash
kubectl apply -f ./kube
```

### Opción 2: Desplegar en orden específico

```bash
# 1. ConfigMap y Secrets
kubectl apply -f kube/configmap.yaml
kubectl apply -f kube/secret.yaml

# 2. Base de datos
kubectl apply -f kube/database-deployment.yaml

# 3. Esperar a que la base de datos esté lista
kubectl wait --for=condition=ready pod -l component=database --timeout=120s

# 4. Backend
kubectl apply -f kube/backend-deployment.yaml

# 5. Frontend
kubectl apply -f kube/frontend-deployment.yaml
```

## Verificación del Despliegue

### 1. Verificar Pods
```bash
kubectl get pods
```

Deberías ver algo como:
```
NAME                                READY   STATUS    RESTARTS   AGE
climapp-backend-xxxxxxxxxx-xxxxx    1/1     Running   0          2m
climapp-db-xxxxxxxxxx-xxxxx         1/1     Running   0          3m
climapp-frontend-xxxxxxxxxx-xxxxx   1/1     Running   0          1m
```

### 2. Verificar Services
```bash
kubectl get svc
```

Deberías ver:
```
NAME                       TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)          AGE
climapp-backend-service    NodePort    10.xxx.xxx.xxx   <none>        8000:30800/TCP   2m
climapp-db-service         ClusterIP   10.xxx.xxx.xxx   <none>        5432/TCP         3m
climapp-frontend-service   NodePort    10.xxx.xxx.xxx   <none>        80:30300/TCP     1m
kubernetes                 ClusterIP   10.96.0.1        <none>        443/TCP          10m
```

### 3. Verificar Deployments
```bash
kubectl get deployments
```

### 4. Verificar PersistentVolumeClaims
```bash
kubectl get pvc
```

### 5. Ver logs de los pods
```bash
# Backend
kubectl logs -l component=backend --tail=50

# Frontend
kubectl logs -l component=frontend --tail=50

# Database
kubectl logs -l component=database --tail=50
```

## Acceder a la Aplicación

### Método 1: Usar minikube service (Recomendado)

```bash
# Frontend
minikube service climapp-frontend-service

# Backend
minikube service climapp-backend-service
```

Esto abrirá automáticamente tu navegador con la URL correcta.

### Método 2: Obtener la URL manualmente

```bash
# Obtener la IP de Minikube
minikube ip

# Acceder a:
# Frontend: http://<minikube-ip>:30300
# Backend: http://<minikube-ip>:30800
```

### Método 3: Port forwarding (Alternativo)

```bash
# Frontend
kubectl port-forward service/climapp-frontend-service 3000:80

# Backend (en otra terminal)
kubectl port-forward service/climapp-backend-service 8090:8000
```

Luego accede a:
- Frontend: http://localhost:3000
- Backend: http://localhost:8090

## Comandos Útiles

### Ver todos los recursos
```bash
kubectl get all
```

### Describir un recurso específico
```bash
kubectl describe pod <pod-name>
kubectl describe service <service-name>
kubectl describe deployment <deployment-name>
```

### Ver logs en tiempo real
```bash
kubectl logs -f <pod-name>
```

### Ejecutar comandos dentro de un pod
```bash
kubectl exec -it <pod-name> -- /bin/bash
```

### Reiniciar un deployment
```bash
kubectl rollout restart deployment/<deployment-name>
```

### Escalar un deployment
```bash
kubectl scale deployment/climapp-backend --replicas=2
```

## Limpieza / Eliminar el Despliegue

### Eliminar todos los recursos
```bash
kubectl delete -f ./kube
```

### Eliminar recursos específicos
```bash
kubectl delete deployment climapp-frontend
kubectl delete service climapp-frontend-service
# ... etc
```

### Detener Minikube
```bash
minikube stop
```

### Eliminar el cluster de Minikube
```bash
minikube delete
```

## Troubleshooting

### Los pods no inician (CrashLoopBackOff)
```bash
kubectl describe pod <pod-name>
kubectl logs <pod-name>
```

### Problemas de conexión a la base de datos
Verifica que el backend pueda resolver el DNS del servicio:
```bash
kubectl exec -it <backend-pod-name> -- nslookup climapp-db-service
```

### Problemas con imágenes
Asegúrate de que Minikube pueda acceder a Docker Hub:
```bash
minikube ssh docker pull emanuelongo2310/backend:latest
minikube ssh docker pull onemayepes/frontend-climapp:latest
```

### El frontend no puede conectarse al backend
Actualiza la variable `NEXT_PUBLIC_API_URL` en el ConfigMap con la URL correcta de Minikube:
```bash
# Obtener la URL del backend
minikube service climapp-backend-service --url

# Actualizar el ConfigMap y reiniciar el frontend
kubectl edit configmap climapp-config
kubectl rollout restart deployment/climapp-frontend
```

## Notas Importantes

1. **Persistencia de Datos**: Los datos de PostgreSQL se almacenan en un PersistentVolumeClaim. Si eliminas el PVC, perderás los datos.

2. **API Keys**: Asegúrate de configurar correctamente las API keys en el archivo `secret.yaml` antes de desplegar.

3. **NodePort**: Los servicios frontend y backend usan NodePort para acceso externo. Los puertos son:
   - Frontend: 30300
   - Backend: 30800

4. **Recursos**: Los warnings sobre recursos son normales en entornos de desarrollo. Para producción, se recomienda agregar límites de recursos.

## Evidencias para el Punto 4

Para completar el punto 4 de tu tarea, ejecuta y guarda capturas de:

```bash
# 1. Estado de los pods
kubectl get pods -o wide

# 2. Estado de los services
kubectl get svc

# 3. Estado de los deployments
kubectl get deployments

# 4. Estado de PVC
kubectl get pvc

# 5. Todos los recursos
kubectl get all

# 6. URL del servicio frontend
minikube service climapp-frontend-service --url

# 7. URL del servicio backend
minikube service climapp-backend-service --url

# 8. Abrir el servicio frontend en el navegador
minikube service climapp-frontend-service
```

¡Buena suerte con tu despliegue! 🚀
