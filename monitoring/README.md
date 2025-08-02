# Monitoring Stack

This folder contains basic setup for:
- Prometheus (metrics collection)
- Grafana (visualization)

## Usage

```bash
cd monitoring
docker-compose up
Prometheus: http://localhost:9090
```

Grafana: http://localhost:3000 (admin/admin)



You can add exporters (e.g., Node Exporter) in future steps.