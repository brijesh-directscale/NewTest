<# Powershell script to remove EB Application Version  #>
	write-host "------------------All EB Application Environment----------------------------"
$EbApplication=Get-EBEnvironment | findstr "ApplicationName" | select -uniq
                         $EbApplication 
                        Echo "`n"
			foreach ($All_EbApplication in $EbApplication ){
				$Split_EbApplication=$All_EbApplication.split(':')[1]
               
				$Trim_EbApplication=$Split_EbApplication.TrimStart()
                      
							Foreach ($count in $Trim_EbApplication) {
								$a=Get-EBApplicationVersion -ApplicationName "$count" | findstr "VersionLabel"
								write-host "Total Versions in "$count" : " @($a).Count
							Echo "`n"
				}
			}
	$TotalEBApplicationVersion=Get-EBApplicationVersion | findstr "VersionLabel"
		write-host "Total EB Versions is: "@($TotalEBApplicationVersion).Count
		Echo "`n"
	$ApplicationName= read-host "Enter EB ApplicationName From which do You want to delete versions"
		write-host "----------------------------------------------"
	$versions= read-host "How many version do you want to delete"
		write-host "----------------------------------------------"

	$command=Get-EBApplicationVersion -ApplicationName "$ApplicationName" | findstr "VersionLabel"
		$AppVersionLabel=$command | select -Last $versions
	 
			 foreach ($SVersionLabel_list in $AppVersionLabel)
			{
				$VersionLabel_list=$SVersionLabel_list.split(':')[1]
				$VersionLabel_list
			
				foreach ($VersionLabel in $VersionLabel_list)
					{
						 $v=$VersionLabel.Trim()
						Remove-EBApplicationVersion -ApplicationName "$ApplicationName" -VersionLabel "$v" -force
					}
			}