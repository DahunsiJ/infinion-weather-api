#!/bin/bash
set -e

echo "🔍 Running SonarQube analysis..."

SONAR_HOST_URL=${SONAR_HOST_URL:-"https://sonarcloud.io"}
SONAR_PROJECT_KEY=${SONAR_PROJECT_KEY:-"infinion-weather-api"}
SONAR_ORG=${SONAR_ORG:-"infinion"}
SONAR_TOKEN=${SONAR_TOKEN:?❌ SONAR_TOKEN not set!}

dotnet sonarscanner begin \
  /k:"$SONAR_PROJECT_KEY" \
  /o:"$SONAR_ORG" \
  /d:sonar.host.url="$SONAR_HOST_URL" \
  /d:sonar.login="$SONAR_TOKEN"

dotnet build

dotnet sonarscanner end /d:sonar.login="$SONAR_TOKEN"

echo "✅ SonarQube analysis completed."
