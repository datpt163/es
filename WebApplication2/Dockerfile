# Sử dụng .NET SDK để build
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build-env
WORKDIR /app

# Copy csproj và restore các package
COPY *.csproj ./
RUN dotnet restore

# Copy toàn bộ mã nguồn và build ứng dụng
COPY . ./
RUN dotnet publish -c Release -o out

# Sử dụng .NET runtime để chạy ứng dụng
FROM mcr.microsoft.com/dotnet/aspnet:8.0
WORKDIR /app
COPY --from=build-env /app/out .

EXPOSE 80

ENTRYPOINT ["dotnet", "WebApplication2.dll"]
