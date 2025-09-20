# Monitoring (Prometheus + Grafana)

Production-style, local monitoring stack for the project. Includes Prometheus (metrics scrape), Node Exporter (host metrics) and Grafana (dashboards) with auto-provisioned datasource & dashboard.

## What you get

### Prometheus scraping:

- prometheus (self)
- node_exporter (CPU/RAM/Disk/Net)
- cloudwatch-exporter (AWS Lambda metrics: Invocations, Errors, Duration, Throttles)

### Grafana:

- Prometheus datasource provisioned automatically
- Node Exporter Full dashboard (ID 1860) preloaded

```bash
monitoring/
├─ docker-compose.yml
├─ prometheus.yml
└─ provisioning/
   ├─ datasources/prometheus.yml
   └─ dashboards/
      ├─ dashboards.yml
      └─ node_exporter.json
```

## Quick start

From repo root:
```bash
docker compose -f monitoring/docker-compose.yml up -d
```
…or from the folder:
```bash
cd monitoring
docker compose up -d
```

### Access:

- Prometheus → http://localhost:9090
- Grafana → http://localhost:3000 (default login: admin / admin)
- Node Exporter → http://localhost:9100/metrics
- CloudWatch Exporter → http://localhost:9106/metrics

## Verify it’s working

### Prometheus

Open **Status → Targets**.  
You should see `prometheus`, `node_exporter` and `cloudwatch-exporter` with state **UP**.

### Grafana

Connections → Data sources: Prometheus should be present.

Dashboards → Browse: Node Exporter Full should be listed and show data.

If the dashboard isn’t there:

- Import manually: Dashboards → Import → ID: 1860 and select Prometheus.
- Or check provisioning mounts (below).

## Useful PromQL to try

```bash
up
node_cpu_seconds_total
node_memory_MemAvailable_bytes
node_filesystem_avail_bytes
rate(node_network_receive_bytes_total[5m])
aws_lambda_invocations_sum
aws_lambda_errors_sum
aws_lambda_duration_average
aws_lambda_throttles_sum
```

## 🛠 Troubleshooting

### Grafana provisioning not working?

```bash
docker ps  # find grafana container name, e.g., monitoring-grafana-1
docker exec -it <grafana> ls /etc/grafana/provisioning/datasources
docker exec -it <grafana> ls /etc/grafana/provisioning/dashboards
```

Look for provisioning logs:
```bash
docker logs <grafana> | grep -i provision
```

### Prometheus shows targets as DOWN?

Verify containers are running:
```bash
docker ps
```

Restart monitoring stack:
```bash
make monitoring-down
make monitoring-up
```

### Node Exporter metrics missing?

Ensure the service is exposed on port 9100:
```bash
curl http://localhost:9100/metrics
```

### CloudWatch Exporter shows no metrics?

- Verify AWS credentials in `~/.aws/credentials`
- Check that `cloudwatch.yml` contains valid region and metrics
- View logs:
```bash
docker logs cloudwatch-exporter
```

---

## 📊 Planned Dashboards

- AWS Lambda performance dashboard (Duration, Errors, Throttles, Invocations)
- Cost Explorer integration (future idea)

