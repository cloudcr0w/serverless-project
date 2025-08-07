#!/bin/bash
curl -s http://localhost:9100/metrics | grep node_cpu_seconds_total
