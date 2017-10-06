# This script requires the following powershell module: https://www.powershellgallery.com/packages/AzureAD
Param (
	[string]$DisplayName,
	[string]$UserName,
	[string]$Password,
	[string]$AppId
)

$secpasswd = ConvertTo-SecureString $Password -AsPlainText -Force
$credential = New-Object System.Management.Automation.PSCredential ($UserName, $secpasswd)

Connect-AzureAD -Credential $credential

$app = Get-AzureADApplication -Filter "DisplayName eq '$($DisplayName)'"

if (!$app)
{
    # Get the "Dynamics CRM Online" service principal
    $svcPrincipal = Get-AzureADServicePrincipal | ? {$_.AppId -match "00000007-0000-0000-c000-000000000000"}

    ### Microsoft Graph
    $reqGraph = New-Object -TypeName "Microsoft.Open.AzureAD.Model.RequiredResourceAccess"
    $reqGraph.ResourceAppId = $svcPrincipal.AppId

    ## Delegated Permissions
    #Access CRM Online as you
    $accessCRMOnlineAsYou = New-Object -TypeName "Microsoft.Open.AzureAD.Model.ResourceAccess" -ArgumentList "78ce3f0f-a1ce-49c2-8cde-64b5c0896db4","Scope"

    # Apply permissions to App
    $reqGraph.ResourceAccess = $accessCRMOnlineAsYou

    $app = New-AzureADApplication -DisplayName "Foo" -PublicClient $true -RequiredResourceAccess $reqGraph
}
else
{
    Write-Output "App already existis"
}

$AppId = $app.AppId
Write-Host "##vso[task.setvariable variable=aadClientId]$AppId"