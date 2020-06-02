FROM mcr.microsoft.com/dotnet/framework/sdk:4.7.2 AS build
ARG proyecto
WORKDIR /app

COPY *.sln .
COPY nuget.config .
COPY WebApi/*.csproj ./WebApi/
COPY WebApp/*.csproj ./WebApp/
COPY WebApi/*.config ./WebApi/
COPY WebApp/*.config ./WebApp/
RUN nuget restore

COPY WebApi/. ./WebApi/
COPY WebApp/. ./WebApp/
WORKDIR /app
RUN msbuild /p:Configuration=Release
RUN msbuild ./WebApi/WebApi.csproj /t:Rebuild /p:Configuration=Release /p:DeployOnBuild=true /p:PublishProfile=FolderProfile

FROM mcr.microsoft.com/dotnet/framework/aspnet:4.7.2 AS runtime
WORKDIR /inetpub/wwwroot
COPY --from=build /app/WebApi/bin/Release/Publish/. ./