# Spring Batch Observability Lab 🛠️📊

Laboratorio completo para monitorizar un batch Spring Boot en Kubernetes usando **Prometheus** y **Grafana** sobre _Minikube_.  
Incluye una versión con **docker-compose** para pruebas locales rápidas.

## Estructura

    compose-lab/            docker-compose (Prometheus + Grafana + batch)
    hello-batch/            aplicación Spring Boot con métrica propia
    hello-batch-chart/      Helm chart (Job + PodMonitor)
    bootstrap.sh            script todo-en-uno para levantar el entorno

## Requisitos

| Herramienta      | Versión probada |
|------------------|-----------------|
| Docker Desktop   | ≥ 4.x (con WSL 2) |
| Minikube         | 1.36            |
| Kubectl          | 1.30 o superior |
| Helm             | 3.18            |
| Bash en WSL 2    | Ubuntu 22/24 |

## Uso rápido (Kubernetes)

    # 1. Clona el repo
    git clone git@github.com:<TU_USUARIO>/spring-batch-observability-lab.git
    cd spring-batch-observability-lab

    # 2. Ejecuta el script
    chmod +x bootstrap.sh
    ./bootstrap.sh

El script:

1. Arranca Minikube (`monitoring-lab`).
2. Compila y construye la imagen `hello-batch:0.1.2`.
3. Instala **kube-prometheus-stack** (Prometheus Operator + Grafana).
4. Despliega el Job `hello-batch` con su **PodMonitor**.
5. Abre Grafana automáticamente.

### Credenciales Grafana

    kubectl -n monitoring get secret monitoring-grafana \
      -o jsonpath="{.data.admin-password}" | base64 -d ; echo

Usuario: `admin`

### Ver métricas

1. En Grafana importa el dashboard **ID 4701** (JVM Micrometer).  
2. Selecciona la variable **job = hello-batch**.  
3. Observa la métrica personalizada `hello_batch_executions_total`.

### Relanzar el batch

    helm -n monitoring uninstall hello-batch
    helm -n monitoring install   hello-batch ./hello-batch-chart --wait

## Uso con docker-compose

    cd compose-lab
    docker compose up --build -d
    # Prometheus  → http://localhost:9090
    # Grafana     → http://localhost:3000  (admin / admin)

## Limpieza

    # Kubernetes
    minikube delete -p monitoring-lab

    # docker-compose
    docker compose down -v

## Licencia
MIT
