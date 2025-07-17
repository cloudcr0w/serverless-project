#!/bin/bash

echo "📦 Building Lambda package..."
cd modules/slack_forwarder
zip lambda.zip slack_alert_forwarder.py
cd -

echo "✅ Lambda package ready locally."
