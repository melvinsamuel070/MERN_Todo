#!/bin/bash

curl -v -X POST -H "Content-Type: application/json" -d '[
  {
    "status": "firing",
    "labels": {
      "alertname": "StatusNotification",
      "severity": "info"
    },
    "annotations": {
      "summary": "Scheduled Status Update",
      "description": "Automated status check running every 2 minutes."
    }
  }
]' http://localhost:9093/api/v2/alerts
