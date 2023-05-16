set APIS=AdopterAPI AnnouncementsAPI ShelterAPI
set NET_VERSION=net7.0

(for %%a in (%APIS%) do ( 
   echo ===============================================
   echo Building %%a
   echo ===============================================
   dotnet build %%a
))