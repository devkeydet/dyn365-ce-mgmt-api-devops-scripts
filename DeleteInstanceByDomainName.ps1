# NOTE:
# I've asked for the project beow to create VSTS tasks so that you don't have to call a powershell script from VSTS:
# https://github.com/WaelHamze/xrm-ci-framework/issues/46
#
# Until then, this will get the job done.
#
# This script requires the following powershell module: https://www.powershellgallery.com/packages/Microsoft.Xrm.OnlineManagementAPI
Param (
	[string]$ApiUrl,
	[System.Management.Automation.PSCredential]$Credential,
	[string]$DomainName
)
$instances = Get-CrmInstances -ApiUrl $ApiUrl -Credential $Credential

$id = $null

foreach ($instance in $instances)
{
	if ($instance.DomainName -eq $DomainName)
	{
		$id = $instance.Id
		break
	}
}

If ($id -ne $null)
{
	$status = Remove-CrmInstance -ApiUrl $ApiUrl -Credential $Credential -Id $id
	#TODO: better status handling
	While ($status.Status -eq "Running" -or $status.Status -eq "NotStarted")
	{
		Write-Output "Delete operation still running.  Sleeping for 30 seconds."
		Start-Sleep -s 30
		$status = Get-CrmOperationStatus -ApiUrl $ApiUrl -Credential $Credential -Id $status.OperationId
	}
}