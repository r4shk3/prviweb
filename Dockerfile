# Use the official .NET runtime image for .NET 9.0
FROM mcr.microsoft.com/dotnet/aspnet:9.0 AS base
WORKDIR /app
EXPOSE 80

# Use the official .NET SDK image for .NET 9.0
FROM mcr.microsoft.com/dotnet/sdk:9.0 AS build
WORKDIR /src
COPY ["MvcMovie.csproj", "./"]
RUN dotnet restore "MvcMovie.csproj"
COPY . .
WORKDIR "/src"
RUN dotnet build "MvcMovie.csproj" -c Release -o /app/build

# Publish the app
FROM build AS publish
RUN dotnet publish "MvcMovie.csproj" -c Release -o /app/publish

# Final stage: runtime image
FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "MvcMovie.dll"]