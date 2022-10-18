#See https://aka.ms/containerfastmode to understand how Visual Studio uses this Dockerfile to build your images for faster debugging.

FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /src
COPY ["Fintech-Api-GateWay/Fintech-Api-GateWay.csproj", "Fintech-Api-GateWay/"]
RUN dotnet restore "Fintech-Api-GateWay/Fintech-Api-GateWay.csproj"
COPY . .
WORKDIR "/src/Fintech-Api-GateWay"
RUN dotnet build "Fintech-Api-GateWay.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "Fintech-Api-GateWay.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
COPY --from=publish /src/Fintech-Api-GateWay/ocelot.json ./
ENTRYPOINT ["dotnet", "Fintech-Api-GateWay.dll"]
