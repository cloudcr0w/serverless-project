 # Monitoring Stack

 This folder contains basic setup for:
 - Prometheus (metrics collection)
 - Grafana (visualization)

 ## Node Exporter

 To enable system metrics, Node Exporter is included.

 Accessible at: http://localhost:9100/metrics

 ## Usage

 ```bash
 cd monitoring
 docker-compose up
 Prometheus: http://localhost:9090
 Grafana: http://localhost:3000
 (admin/admin)
```

-You can add exporters (e.g., Node Exporter) in future steps.

## Grafana

Accessible at: [http://localhost:3000](http://localhost:3000)  

Login: `admin` / `admin`  

Prometheus datasource is provisioned automatically, no manual setup required.  

Next steps: add dashboards (e.g., Node Exporter).
