#!/bin/bash

echo "🚀 Starting Flask app with Gunicorn..."
exec gunicorn -w 4 -b 0.0.0.0:5000 flask_app:app
