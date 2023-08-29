# Koristimo oficijelni .NET Core SDK kao bazni image za izgradnju
FROM mcr.microsoft.com/dotnet/sdk:7.0 AS build

# Postavljanje radnog direktorijuma u kojem će se izvršavati naredbe
WORKDIR /app

# Kopiranje .csproj fajlova i obavljanje restore operacije
COPY *.csproj ./
RUN dotnet restore

# Kopiranje celog projekta i buildovanje
COPY . .
RUN dotnet publish -c Release -o out

# Koristimo bazni image za runtime
FROM mcr.microsoft.com/dotnet/aspnet:7.0 AS runtime
WORKDIR /app
COPY --from=build /app/out ./

# Ekspozicija porta na kojem će aplikacija slušati
EXPOSE 80

# Pokretanje ASP.NET Core aplikacije
ENTRYPOINT ["dotnet", "HelloWorldASP.dll"]
