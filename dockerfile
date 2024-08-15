FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build-env
WORKDIR /App

#Copy everthing
COPY . ./
# Restore as distinct layers
RUN dotnet Restore

# Build and publish a release
RUN dotnet publish Docker.generated.sln -c release -o out

# Build runtime image
FROM mcr.microsoft.com/dotnet/aspnet:8.0
WORKDIR /App
COPY --from=build-env /App/out .
ENTRYPOINT [ "dotnet", "Docker.dll" ]
