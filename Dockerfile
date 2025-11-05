# syntax=docker/dockerfile:1.5
###############################################################################
# Stage 0: build - restore & publish the app
###############################################################################
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src

# Copy only solution & project files first to leverage docker layer cache
COPY *.sln ./
COPY *.csproj ./
COPY . ./

# Explicitly restore this project
RUN dotnet restore "InfinionDevOps.csproj" --disable-parallel

# Build & publish (trim to reduce size; no single-file for easier debugging)
RUN dotnet publish "InfinionDevOps.csproj" -c Release -o /app/publish --no-restore \
    -p:PublishTrimmed=true \
    -p:PublishSingleFile=false

###############################################################################
# Stage 1: runtime - smaller image, non-root user, trimmed runtime
###############################################################################
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS runtime

# Create non-root user and dedicated app directory
RUN useradd -u 1001 -m appuser \
 && mkdir /app \
 && chown -R appuser:appuser /app

WORKDIR /app
COPY --from=build /app/publish/ ./

# Expose the port the app listens on (match Program.cs)
ENV ASPNETCORE_URLS=http://+:5167
EXPOSE 5167

# Security: run as non-root
USER appuser

ENTRYPOINT ["dotnet", "InfinionDevOps.dll"]
