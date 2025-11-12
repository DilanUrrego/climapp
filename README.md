# Climapp

Proyecto semestral que implementa una aplicación de clima con **frontend, backend y base de datos**.
El objetivo es practicar contenerización, comunicación entre servicios y despliegue con **Docker y Docker Compose**.
Hecho por: Valentina Carmona G, Emanuel Gallego C, Dilan Arley Urrego C & Juan Manuel Yepes M.

---

## Tecnologías usadas

### Frontend

* **Next.js 14**
* **React 18**
* **Node.js 18 (alpine en Docker)**
* Estilos con **Tailwind CSS**

### Backend

* **Python 3.13 (slim en Docker)**
* **FastAPI** (framework web)
* **Uvicorn** (servidor ASGI)
* **SQLAlchemy + Pydantic v2**

### Base de datos

* **PostgreSQL 15**

### Contenedores

* **Docker** (última versión recomendada)
* **Docker Compose v3.9**

---

## Estructura del proyecto

```
configProject/
│── backend/         # Código de la API (FastAPI)
│   ├── app/
│   ├── requirements.txt
│   └── Dockerfile
│
│── frontend/climapp       # Aplicación Next.js
│   ├── app/
│   ├── package.json
│   └── Dockerfile
│
│── docker-compose.yaml
│── README.md
```

---

## Instalación y ejecución

### 1. Clonar el repositorio

```bash
git clone https://github.com/...git
cd configProject
```

### 2. Variables de entorno

En `backend/.env`:

```env
POSTGRES_USER=climapp_user
POSTGRES_PASSWORD=climapp_pass
POSTGRES_DB=climapp_db
DATABASE_URL=postgresql+psycopg2://climapp_user:climapp_pass@db:5432/climapp_db
```

En `frontend/.env.local`:

```env
NEXT_PUBLIC_API_URL=http://backend:8000
```

### 3. Construir e iniciar servicios con Docker Compose

```bash
docker-compose up --build
```

---

## Imágenes en DockerHub

Cada aplicación cuenta con su respectiva imagen en **DockerHub**:

* Frontend: `docker pull onemayepes/climapp-frontend:latest`
* Backend: `docker pull emanuelongo2310/backend:latest`
* Base de datos: se usa la oficial `postgres:15`

---

## Flujo de prueba

1. **Frontend** estará disponible en:
   👉 [http://localhost:3000](http://localhost:3000)

2. **Backend (FastAPI + Swagger)** estará en:
   👉 [http://localhost:8090/docs](http://localhost:8090/docs)

3. **Prueba de comunicación completa**:

   * Desde el frontend buscar clima (ej: Medellín)
   * El frontend llama al backend (`/clima/actual` y `/clima/historial`)
   * El backend consulta y guarda en la base de datos PostgreSQL
   * https://youtu.be/8vULp26hiKg

---
