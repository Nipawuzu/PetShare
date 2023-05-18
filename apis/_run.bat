setlocal enabledelayedexpansion
set NET_VERSION=net7.0

set APIS_COUNT=2
set APIS[0]=AdopterAPI
set APIS[0].PORT=7290
set APIS[1]=AnnouncementsAPI
set APIS[1].PORT=4301
set APIS[2]=ShelterAPI
set APIS[2].PORT=7060

for /l %%x in (0, 1, %APIS_COUNT%) do (
    start cmd /k dotnet run --project !APIS[%%x]! --urls=https://localhost:!APIS[%%x].PORT!
)

./_ports.bat