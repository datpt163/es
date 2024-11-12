# syntax=docker/dockerfile:1
# Tạo một giai đoạn để build ứng dụng.
FROM --platform=$BUILDPLATFORM mcr.microsoft.com/dotnet/sdk:8.0-alpine AS build

# Sao chép toàn bộ mã nguồn vào thư mục /source
COPY . /source

# Chuyển đến thư mục chứa file .csproj
WORKDIR /source/WebApplication2

# Biến TARGETARCH sẽ được truyền vào khi build
ARG TARGETARCH

# Build ứng dụng
RUN --mount=type=cache,id=nuget,target=/root/.nuget/packages \
    dotnet publish -c Release -a ${TARGETARCH/amd64/x64} --use-current-runtime --self-contained false -o /app

# Tạo giai đoạn chạy ứng dụng
FROM mcr.microsoft.com/dotnet/aspnet:8.0-alpine AS final
WORKDIR /app

# Cài đặt thư viện ICU
RUN apk add icu-libs
ENV DOTNET_SYSTEM_GLOBALIZATION_INVARIANT=false

# Sao chép ứng dụng đã build từ giai đoạn trước
COPY --from=build /app .

# Chạy ứng dụng
ENTRYPOINT ["dotnet", "WebApplication2.dll"]