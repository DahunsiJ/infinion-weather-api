# syntax=docker/dockerfile:1.5

###############################################################################
# Stage 0: build - restore & publish the app
###############################################################################
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src

# Copy only project files first to leverage Docker cache
COPY *.sln ./
COPY *.csproj ./
COPY . ./

# Restore dependencies (target Linux)
RUN dotnet restore "InfinionDevOps.csproj" --disable-parallel

# Build & publish app for release
RUN dotnet publish "InfinionDevOps.csproj" -c Release -o /app/publish --no-restore \
    -p:PublishTrimmed=true \
    -p:PublishSingleFile=false

###############################################################################
# Stage 1: runtime - lightweight container
###############################################################################
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS runtime

# Create a non-root user
RUN useradd -u 1001 -m appuser \
 && mkdir /app \
 && chown -R appuser:appuser /app

WORKDIR /app

# Copy from build stage
COPY --from=build /app/publish/ ./

# Set environment & expose port
ENV ASPNETCORE_URLS=http://+:5167
EXPOSE 5167

# Run as non-root user
USER appuser

ENTRYPOINT ["dotnet", "InfinionDevOps.dll"]
