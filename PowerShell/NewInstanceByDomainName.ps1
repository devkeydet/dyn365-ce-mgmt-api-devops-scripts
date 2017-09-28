#NOTE: This script requires the following powershell module: https://www.powershellgallery.com/packages/Microsoft.Xrm.OnlineManagementAPI
Param (
	[string]$ApiUrl,
	[System.Management.Automation.PSCredential]$Credential,
	[int]$BaseLanguage,
	[string]$DomainName,
	[string]$FriendlyName,
	[string]$InitialUserEmail,
	[System.Guid]$ServiceVersionId,
	[string]$InstanceType
)


$info = New-CrmInstanceInfo -BaseLanguage $BaseLanguage -DomainName $DomainName -FriendlyName $FriendlyName -InitialUserEmail $InitialUserEmail  -ServiceVersionId $ServiceVersionId -InstanceType $InstanceType

New-CrmInstance -ApiUrl $ApiUrl -Credential $Credential  -NewInstanceInfo $info