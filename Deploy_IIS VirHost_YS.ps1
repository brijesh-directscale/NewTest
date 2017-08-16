
echo "Delete SHD-Office if already available."
#Remove-Item -Recurse -Force C:\Jenkins-Projects\Youngevity-Office-Live\SHD-Office

echo "Delete SHD-Shop if already available."
#Remove-Item -Recurse -Force C:\Jenkins-Projects\Youngevity-Office-Live\SHD-Shop

echo "Cloning Youngevity-Office-Live\SHD-Office"
#git clone -b SHD-Office  https://github.com/wsimlm/Youngevity-PartyPlan.git C:\Jenkins-Projects\Youngevity-Office-Live\SHD-Office

echo "Cloning Youngevity-Office-Live\SHD-Shop"
#git clone -b SHD-Shop  https://github.com/wsimlm/Youngevity-PartyPlan.git C:\Jenkins-Projects\Youngevity-Office-Live\SHD-Shop

cd C:\Jenkins-Projects\Youngevity-Office-Live\SHD-Office
git pull

cd C:\Jenkins-Projects\Youngevity-Office-Live\SHD-Shop
git pull

Remove-Item -Recurse -Force C:\Jenkins-Projects\Youngevity-Office-Live\Youngevity-Office-Live-bundle\WebOffice.zip

Remove-Item -Recurse -Force C:\Jenkins-Projects\Youngevity-Office-Live\Youngevity-Office-Live-bundle\Youngevity-PartyPlan.zip

Set-Alias msdeploy  "C:\Program Files\IIS\Microsoft Web Deploy V3\msdeploy.exe"

msdeploy -verb:sync -source:manifest=C:\Jenkins-Projects\Youngevity-Office-Live\YoungevityLive-WebOffice-Manifest.xml -dest:package=C:\Jenkins-Projects\Youngevity-Office-Live\Youngevity-Office-Live-bundle\WebOffice.zip   -declareParamFile:C:\Jenkins-Projects\Youngevity-Office-Live\YoungevityLive-WebOffice-Parameter.xml

msdeploy -verb:sync -source:manifest=C:\Jenkins-Projects\Youngevity-Office-Live\YoungevityLive-Shop-Manifest.xml -dest:package=C:\Jenkins-Projects\Youngevity-Office-Live\Youngevity-Office-Live-bundle\Youngevity-PartyPlan.zip   -declareParamFile:C:\Jenkins-Projects\Youngevity-Office-Live\YoungevityLive-Shop-Parameter.xml


cd C:\Jenkins-Projects\Youngevity-Office-Live\Youngevity-Office-Live-bundle
$versionPrefix = "Live"
$versionLabel = "$versionPrefix" +"-v"+ (Get-Date).ToString("yyyyMMddhhmm")
eb init "Youngevity Office" --region  us-east-1 --platform iis-8.5
eb deploy "youngevityOffice-live" --region  us-east-1 --label $versionLabel