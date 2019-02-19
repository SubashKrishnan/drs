FROM microsoft/dotnet:2.2-aspnetcore-runtime AS base
WORKDIR /app
EXPOSE 80

FROM microsoft/dotnet:2.2-sdk AS build
WORKDIR /src
COPY ["DRS/DRS.csproj", "DRS/"]
RUN dotnet restore "DRS/DRS.csproj"
COPY . .
WORKDIR "/src/DRS"
RUN dotnet build "DRS.csproj" -c Release -o /app

FROM build AS publish
RUN dotnet publish "DRS.csproj" -c Release -o /app

FROM base AS final
WORKDIR /app
COPY --from=publish /app .
ENTRYPOINT ["dotnet", "DRS.dll"]