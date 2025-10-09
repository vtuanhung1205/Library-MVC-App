FROM registry.fedoraproject.org/fedora:40

# Cài Mono + NuGet + XSP (web server ASP.NET)
RUN dnf -y update && \
    dnf -y install mono-complete mono-devel nuget xsp && \
    dnf clean all

WORKDIR /app
COPY . .

# Hạ target để Mono build được
RUN sed -i 's#<TargetFrameworkVersion>v4.7.2</TargetFrameworkVersion>#<TargetFrameworkVersion>v4.7.1</TargetFrameworkVersion>#' ./library/library.csproj || true

# Chỉ reference assemblies của Mono
ENV FrameworkPathOverride=/usr/lib/mono/4.7.1-api

# Restore & build (packages.config)
RUN nuget restore ./library.sln -PackagesDirectory ./packages && \
    FrameworkPathOverride=$FrameworkPathOverride xbuild ./library.sln /p:Configuration=Release /p:TargetFrameworkVersion=v4.7.1

# Chạy web ở thư mục project (nơi có Web.config)
WORKDIR /app/library
EXPOSE 5000

# ✅ Gọi trực tiếp binary xsp4 được cài từ gói 'xsp'
CMD ["/usr/bin/xsp4", "--port", "5000", "--address", "0.0.0.0", "--nonstop"]
