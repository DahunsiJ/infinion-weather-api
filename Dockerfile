# syntax=docker/dockerfile:1.5
###############################################################################
# Stage 0: build - restore & publish the app
###############################################################################
FROM mcr.microsoft.com/dotnet/sdk:7.0 AS build
WORKDIR /src

# Copy only solution & project files first to leverage docker layer cache
COPY *.sln ./
COPY src/ ./src/
# Copy any top-level csproj files if needed (some repos have them outside src)
COPY *.csproj ./

# Restore dependencies (disable parallel to avoid race conditions on CI runners)
RUN dotnet restore --disable-parallel

# Build & publish (trim to reduce size; don't publish single-file to keep debugging simple)
RUN dotnet publish ./src -c Release -o /app/publish --no-restore -p:PublishTrimmed=true -p:PublishSingleFile=false

###############################################################################
# Stage 1: runtime - smaller image, non-root user, trimmed runtime
###############################################################################
FROM mcr.microsoft.com/dotnet/aspnet:7.0 AS runtime

# Create non-root user and dedicated app directory
RUN useradd -u 1001 -m appuser \
 && mkdir /app \
 && chown -R appuser:appuser /app

WORKDIR /app
COPY --from=build /app/publish/ ./

# Expose only the port the app listens on (match Program.cs)
ENV ASPNETCORE_URLS=http://+:5167
EXPOSE 5167

# Security: run as non-root
USER appuser

# Do not set sensitive environment variables here in image (set in runtime env / k8s)
ENTRYPOINT ["dotnet", "InfinionDevOps.dll"]
