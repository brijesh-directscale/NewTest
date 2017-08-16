<# Provide the Client & Application Name #>
	$Client_Name = Read-Host "Enter Client Name" <#Provide Client Name like , Client, POD {TagName}#>
	$Application = Read-Host "Enter Application Name" <#Provide Application Name like MyntWebapp, DiSCoWebapp.... {TagValue}#>

	<#Find the Resources (webapps) with the Tags Name & Value#>	
	$command= Find-AzureRmResource -TagName "$Client_Name" -TagValue "$Application" |where-object ResourceType -eq "microsoft.web/sites" 

		If ($command -eq $NULL) {
							
							write-host "NO Resources FOUND" 
					 }
		Else {
				<# Pick Up the ResouceGroupName #>
				$ResourceGroupName=$command | findstr "ResourceGroupName"
				$TResourceGroupName=$ResourceGroupName.split(':')[1].split(' ')[1]
				Echo "`n---Resourse Group Name---"
				$TResourceGroupName  
				Echo "`n"

				<# Pick Up the ResouceName #>
				$ResourceName=$command | findstr "ResourceName"
				$TResourceName=$ResourceName.split(':')[1].split(' ')[1]
				Echo "---Web App Name---"
				$TResourceName	
				Echo "`n"
	
				$WEBSITE_URL="$TResourceName.azurewebsites.net"
				Echo "---Web App URL---"
				$WEBSITE_URL
				Echo "`n"
	
	
						$Var = @("directscale.xyz." , "directscale.com." , "directscaledev.com." , "directscalestage.com.")
						Echo "---HostedZones---`n"
						$Var
						
						$HostedZoneIds = @("Z2IDR14MYAFSW5" , "Z1SULWZ4I6YS17" , "Z2KWSAPKW6I8S2" , "Z2JA82GYERKIZH")
						
						for( $i = 0; $i -lt $Var.length; $i++) {

						$HostedZone = $Var[$i]
						$HostedZoneId = $HostedZoneIds[$i]
						
						$change = New-Object Amazon.Route53.Model.Change
						$change.Action = "CREATE"
						$change.ResourceRecordSet = New-Object Amazon.Route53.Model.ResourceRecordSet
						$change.ResourceRecordSet.Name = "$Client_Name.corpadmin.$HostedZone"
						$change.ResourceRecordSet.Type = "CNAME"
						$change.ResourceRecordSet.TTL = 300
						$change.ResourceRecordSet.ResourceRecords.Add(@{Value="$WEBSITE_URL"})

						$params = @{
						
						HostedZoneId="$HostedZoneId"
						ChangeBatch_Comment="created a TXT record for $HostedZone and changes the A record for $Client_Name.corpadmin.$HostedZone"
						ChangeBatch_Change=$change
					}
					$ErrorActionPreference= 'silentlycontinue'
					$Result=Edit-R53ResourceRecordSet @params
					if ($? -eq $False){
						
						Echo "`nDNS Entry Already Exist"
					Get-R53ResourceRecordSet -HostedZoneId /hostedzone/$HostedZoneId| Select-Object -ExpandProperty ResourceRecordSets | % {$_.Name} | findstr "$Client_Name.corpadmin.$HostedZone"
						Echo "`n"	
					}
						
				
				}
				
				Set-AzureRmWebapp -Name "$TResourceName" -ResourceGroupName "$TResourceGroupName" -HostNames @("$WEBSITE_URL","$Client_Name.corpadmin.directscale.xyz","$Client_Name.corpadmin.directscale.com","$Client_Name.corpadmin.directscaledev.com","$Client_Name.corpadmin.directscalestage.com") -WarningAction silentlyContinue


			}