#!/bin/bash

# Health check for frontend
FRONTEND_HEALTH=$(curl -s -o /dev/null -w "%{http_code}" http://$EC2_PUBLIC_IP:$FRONTEND_PORT/health)

# Health check for backend
BACKEND_HEALTH=$(curl -s -o /dev/null -w "%{http_code}" http://$EC2_PUBLIC_IP:$BACKEND_PORT/api/health)

# Email notification function
send_notification() {
    echo "$1" | mail -s "Service Health Check Alert" $EMAIL
}

# Check frontend health
if [ $FRONTEND_HEALTH -ne 200 ]; then
    send_notification "Frontend service is down. HTTP Code: $FRONTEND_HEALTH"
    curl -X POST -d '{"status": "down", "service": "frontend"}' http://localhost:9093/api/v1/alerts  # Trigger AlertManager alert
fi

# Check backend health
if [ $BACKEND_HEALTH -ne 200 ]; then
    send_notification "Backend service is down. HTTP Code: $BACKEND_HEALTH"
    curl -X POST -d '{"status": "down", "service": "backend"}' http://localhost:9093/api/v1/alerts  # Trigger AlertManager alert
fi
